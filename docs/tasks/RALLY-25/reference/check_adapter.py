"""Failure/state tests of Rally host scaffolding, never Golem qualification."""
import json,unittest
from freeze import HERE,sha
from root_adapter import Binding,Interface,Rejected,RuntimeRejected,read,write,stub_invoke,require_success

class AdapterChecks(unittest.TestCase):
    def setUp(self):
        # Synthetic nonsequential IDs deliberately exercise generated mappings.
        self.spec=Interface(120,dict(zip(('InitRace','Tick120','Render30','ResetRace','StopRace'),(11,37,5,83,2))),
                            (Binding(1,901,4,8,1),Binding(2,907,0,16,3),Binding(3),Binding(4)))
        self.root=self.spec.initial(123)
        self.lengths={901:12,907:16}
    @staticmethod
    def source(root):write(root,112,read(root,112)+1);return 0
    def test_success_and_wrap(self):
        for prior in [0,4294967295]:
            write(self.root,20,prior,'I');write(self.root,16,-321,'i')
            stub_invoke(self.root,self.spec,'Tick120',self.source,self.lengths)
            self.assertEqual(require_success(self.root,self.spec,'Tick120',123,prior,0),(prior+1)&4294967295)
            self.assertEqual(read(self.root,16,'i'),-321) # wrapper never publishes host result
    def test_rejection_preserves_prior_effects(self):
        for offset,value,status in [(0,0,1),(2,2,2),(4,110,3),(6,119,3),(26,3,3),(36,4,3),(38,9,3),
                                    (8,0,4),(50,902,5),(30,1,6),(40,1,6),(44,0,6)]:
            with self.subTest(offset=offset):
                root=self.spec.initial(123);write(root,14,4);write(root,20,88,'I');write(root,112,42)
                write(root,offset,value,'I' if offset in (8,40,44) else 'H');before=bytes(root)
                stub_invoke(root,self.spec,'Tick120',self.source,self.lengths)
                self.assertEqual(read(root,12),status)
                permitted=bytearray(before);write(permitted,12,status);write(permitted,28,37)
                self.assertEqual(root,permitted)
    def test_native_ranges_and_stock_limit(self):
        before=bytes(self.root);stub_invoke(self.root,self.spec,'Tick120',self.source,{901:11,907:16})
        self.assertEqual(read(self.root,12),8);self.assertEqual(self.root[112:],before[112:])
        stub_invoke(self.root,self.spec,'Tick120',self.source,None)
        self.assertEqual(read(self.root,112),1) # stock trusts host-declared lifetime/ranges
    def test_language_failure_retains_earlier_effect(self):
        def failed(root):write(root,112,7);return 4
        stub_invoke(self.root,self.spec,'Tick120',failed,self.lengths)
        self.assertEqual(read(self.root,112),7);self.assertEqual(read(self.root,14),4)
        self.assertEqual(read(self.root,20,'I'),0);self.assertEqual(read(self.root,24),65535)
        with self.assertRaises(Rejected):require_success(self.root,self.spec,'Tick120',123,0,0)
    def test_no_safe_write_on_sdk_or_physical_rejection(self):
        for root,name in [(self.root,'missing'),(self.root[:111],'Tick120'),(self.root[:-1],'Tick120')]:
            before=bytes(root)
            with self.assertRaises(RuntimeRejected):stub_invoke(root,self.spec,name,self.source,self.lengths)
            self.assertEqual(bytes(root),before)
    def test_stale_and_cross_channel_failures(self):
        stub_invoke(self.root,self.spec,'Tick120',self.source,self.lengths)
        for name,session,prior,result in [('Tick120',123,0,None),('Tick120',123,0,-1),('Render30',123,0,0),
                                           ('Tick120',124,0,0),('Tick120',123,1,0)]:
            with self.assertRaises(Rejected):require_success(self.root,self.spec,name,session,prior,result)
        for offset in (12,14):
            root=bytearray(self.root);write(root,offset,1)
            with self.assertRaises(Rejected):require_success(root,self.spec,'Tick120',123,0,0)
    def test_generic_unknown_entry(self):
        from root_adapter import metadata_status
        write(self.root,28,999);self.assertEqual(metadata_status(self.root,self.spec),7)
    def test_invalid_normalized_bindings(self):
        for b in [Binding(1,0,0,1,0),Binding(1,3,0,8,3),Binding(2,3,4294967295,2,3)]:
            with self.assertRaises(Rejected):b.encoded()
    def test_generated_entry_count(self):
        spec=Interface(120,dict(self.spec.entries,Diagnostic=93),self.spec.bindings)
        root=spec.initial(123)
        self.assertEqual(read(root,36),6)
        stub_invoke(root,spec,'Diagnostic',self.source,self.lengths)
        self.assertEqual(require_success(root,spec,'Diagnostic',123,0,0),1)

if __name__=='__main__':
    result=unittest.TextTestRunner(verbosity=2).run(unittest.defaultTestLoader.loadTestsFromTestCase(AdapterChecks))
    receipt=dict(schema=1,scope='host-only adapter/stub; no Golem/SDK/emulator execution',tests=result.testsRun,
                 failures=len(result.failures),errors=len(result.errors),files={p.name:sha(p.read_bytes()) for p in [HERE/'root_adapter.py',HERE/'check_adapter.py']})
    (HERE/'adapter-verification.json').write_text(json.dumps(receipt,indent=2)+'\n')
    raise SystemExit(not result.wasSuccessful())
