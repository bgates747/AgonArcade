; ModuleID = 'src/main.cpp'
source_filename = "src/main.cpp"
target datalayout = "e-m:z-p:24:8-p1:16:8-p2:8:8-p3:16:8-p4:24:8-i16:8-i24:8-i32:8-i48:8-i64:8-i96:8-f32:8-f64:8-a:8-n8:16:24-S8"
target triple = "ez80-none-unknown-elf"

%"struct.rally::DirectRoad" = type { %"struct.rally::Road", i32, i32, %"struct.rally::Sample" }
%"struct.rally::Road" = type { ptr, i8, ptr, [129 x i32], [129 x i32], [225 x i32], [225 x i8], i24 }
%"struct.rally::Sample" = type { i32, i32, i32, i32 }
%"struct.rally::Stream" = type { [4096 x i8], i24, i8 }
%"struct.rally::game::Billboards" = type { [2 x %"struct.rally::game::SignPose"], i24 }
%"struct.rally::game::SignPose" = type { i24, i24, i24, i24 }
%"struct.rally::Motion" = type { ptr, i32, i32, i32, i32, i32, i16, i16, i24, i8 }
%"struct.rally::TrackDef" = type { ptr, i24, i32, ptr }
%"struct.rally::game::Rules" = type { %"struct.rally::game::Settings", i8, i8, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i16, i16, i8, i8, i8, i24 }
%"struct.rally::game::Settings" = type { i16, i16, i16, i16, i8 }
%"struct.rally::game::Records" = type { [288 x %"struct.rally::game::Record"] }
%"struct.rally::game::Record" = type { i32, i32 }
%"struct.rally::game::Engine" = type { i8, i24 }
%"struct.rally::DemoDriver" = type { i24 }
%"struct.rally::Traffic" = type { [6 x %"struct.rally::Opponent"] }
%"struct.rally::Opponent" = type { i32, i24, i24 }
%"struct.rally::game::RaceTraffic" = type { [6 x %"struct.rally::game::RaceCar"], %"struct.rally::game::RouteCursor", i8, i32, i32, i32, i8 }
%"struct.rally::game::RaceCar" = type { i8, i16, i8, i32, i32, i32, i32, %"struct.rally::game::RouteCursor" }
%"struct.rally::game::RouteCursor" = type { i8, i16, i16, i32 }
%"struct.rally::SceneryHistory" = type { [2 x i24], [2 x i8], i24 }
%"struct.rally::r18::SceneState" = type { i24, i24, i24, i24, i8, i24, i24, i24, i8, i24, [6 x %"struct.rally::r18::CarState"] }
%"struct.rally::r18::CarState" = type { i24, i24, i24, i24, i24, i24, i24, i8 }
%"struct.rally::TrackPoint" = type { i16, i16, i16, i16 }
%"struct.rally::game::SignArt" = type { [16 x i8], [2048 x i8] }
%"struct.rally::game::Crash" = type { i16, i16 }
%"struct.rally::game::RouteRecord" = type { i16, i16, i16, i16 }
%"struct.rally::game::Hud" = type { [2 x %"struct.rally::game::HudImage"], [2 x i8] }
%"struct.rally::game::HudImage" = type { [120 x i8], [120 x i8] }
%"struct.rally::SceneryUpdate" = type { i24, i24, i24, i8 }
%"struct.rally::r18::Pose" = type { i8, i8 }

@_ZN12_GLOBAL__N_14roadE = internal global %"struct.rally::DirectRoad" { %"struct.rally::Road" { ptr @_ZN5rallyL4FujiE, i8 0, ptr @_ZN5rallyL8BandEndsE, [129 x i32] zeroinitializer, [129 x i32] zeroinitializer, [225 x i32] zeroinitializer, [225 x i8] zeroinitializer, i24 0 }, i32 0, i32 0, %"struct.rally::Sample" { i32 0, i32 0, i32 4096, i32 0 } }, align 1
@_ZN12_GLOBAL__N_16streamE = internal global %"struct.rally::Stream" zeroinitializer, align 1
@_ZN12_GLOBAL__N_110billboardsE = internal global %"struct.rally::game::Billboards" zeroinitializer, align 1
@_ZN12_GLOBAL__N_16motionE = internal global %"struct.rally::Motion" { ptr @_ZN5rallyL4FujiE, i32 0, i32 0, i32 0, i32 0, i32 0, i16 0, i16 0, i24 60, i8 1 }, align 1
@.str = private unnamed_addr constant [5 x i8] c"oval\00", align 1
@_ZN5rallyL7TriOvalE = internal constant %"struct.rally::TrackDef" { ptr @_ZN5rallyL13TriOvalPointsE, i24 90, i32 5760, ptr @.str.13 }, align 1
@_ZN12_GLOBAL__N_18selectedE = internal unnamed_addr global ptr @_ZN5rallyL7TriOvalE, align 1
@.str.3 = private unnamed_addr constant [5 x i8] c"fuji\00", align 1
@_ZN5rallyL4FujiE = internal constant %"struct.rally::TrackDef" { ptr @_ZN5rallyL10FujiPointsE, i24 512, i32 32768, ptr @.str.14 }, align 1
@.str.4 = private unnamed_addr constant [5 x i8] c"mute\00", align 1
@_ZN12_GLOBAL__N_15mutedE = internal unnamed_addr global i8 0, align 1
@.str.5 = private unnamed_addr constant [7 x i8] c"steer1\00", align 1
@_ZN12_GLOBAL__N_112steeringStepE = internal unnamed_addr global i1 false, align 1
@.str.6 = private unnamed_addr constant [7 x i8] c"steer2\00", align 1
@.str.7 = private unnamed_addr constant [7 x i8] c"arcade\00", align 1
@_ZN12_GLOBAL__N_15rulesE = internal global %"struct.rally::game::Rules" { %"struct.rally::game::Settings" { i16 20, i16 11, i16 20, i16 16, i8 6 }, i8 0, i8 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i16 0, i16 0, i8 0, i8 7, i8 7, i24 60 }, align 1
@.str.8 = private unnamed_addr constant [8 x i8] c"circuit\00", align 1
@.str.9 = private unnamed_addr constant [5 x i8] c"demo\00", align 1
@.str.11 = private unnamed_addr constant [10 x i8] c"rally.sav\00", align 1
@_ZN12_GLOBAL__N_17recordsE = internal global %"struct.rally::game::Records" zeroinitializer, align 1
@.str.12 = private unnamed_addr constant [10 x i8] c"rally.bak\00", align 1
@_ZN12_GLOBAL__N_16engineE = internal global %"struct.rally::game::Engine" zeroinitializer, align 1
@_ZN12_GLOBAL__N_14quitE = internal unnamed_addr global i1 false, align 1
@_ZN12_GLOBAL__N_112previousKeysE = internal unnamed_addr global [16 x i8] zeroinitializer, align 1
@_ZN12_GLOBAL__N_18heldKeysE = internal global [16 x i8] zeroinitializer, align 1
@_ZN12_GLOBAL__N_110demoDriverE = internal global %"struct.rally::DemoDriver" { i24 224 }, align 1
@_ZN12_GLOBAL__N_17trafficE = internal global %"struct.rally::Traffic" zeroinitializer, align 1
@_ZN12_GLOBAL__N_111raceTrafficE = internal global %"struct.rally::game::RaceTraffic" { [6 x %"struct.rally::game::RaceCar"] [%"struct.rally::game::RaceCar" { i8 0, i16 0, i8 0, i32 0, i32 0, i32 0, i32 0, %"struct.rally::game::RouteCursor" { i8 0, i16 60, i16 0, i32 0 } }, %"struct.rally::game::RaceCar" { i8 0, i16 0, i8 0, i32 0, i32 0, i32 0, i32 0, %"struct.rally::game::RouteCursor" { i8 0, i16 60, i16 0, i32 0 } }, %"struct.rally::game::RaceCar" { i8 0, i16 0, i8 0, i32 0, i32 0, i32 0, i32 0, %"struct.rally::game::RouteCursor" { i8 0, i16 60, i16 0, i32 0 } }, %"struct.rally::game::RaceCar" { i8 0, i16 0, i8 0, i32 0, i32 0, i32 0, i32 0, %"struct.rally::game::RouteCursor" { i8 0, i16 60, i16 0, i32 0 } }, %"struct.rally::game::RaceCar" { i8 0, i16 0, i8 0, i32 0, i32 0, i32 0, i32 0, %"struct.rally::game::RouteCursor" { i8 0, i16 60, i16 0, i32 0 } }, %"struct.rally::game::RaceCar" { i8 0, i16 0, i8 0, i32 0, i32 0, i32 0, i32 0, %"struct.rally::game::RouteCursor" { i8 0, i16 60, i16 0, i32 0 } }], %"struct.rally::game::RouteCursor" { i8 0, i16 60, i16 0, i32 0 }, i8 0, i32 0, i32 0, i32 0, i8 1 }, align 1
@_ZN12_GLOBAL__N_114sceneryHistoryE = internal global %"struct.rally::SceneryHistory" zeroinitializer, align 1
@_ZN12_GLOBAL__N_15sceneE = internal global %"struct.rally::r18::SceneState" zeroinitializer, align 1
@_ZN12_GLOBAL__N_111savePendingE = internal unnamed_addr global i8 0, align 1
@__const._Z8gameMainiPPc.fonts = private unnamed_addr constant [2 x i24] [i24 63940, i24 63941], align 1
@_ZN5rallyL8BandEndsE = internal constant [16803 x i8] c"hikoy\8C\A5\DFhikoz\8F\AF\DFhiko{\8F\A4\C1\DFhikns\7F\9B\CE\DFhijlq\7F\99\B0\DFhijlpz\86\AC\DFhijlou\84\A6\C2\DFhijlou\86\AA\CF\DFhijlov\89\B3\DFhijknt\88\98\D9\DFhijkns{\93\D3\DFhijkmqy\94\A9\DFhijlou~\9D\B7\DFhijlot}\9D\B5\DFhijlot}\A0\BE\DFhijlnr{\94\CC\DFhijlmqw\82\B0\DFhijkmos|\88\BC\DFhijkmos{\88\C9\DFhijkmot|\8A\DC\DFhijkmot|\8D\DFhijklorw\82\93\DFhijkmpu|\92\DFhijkmpsx\82\9C\DFhijklmpry\84\A3\DFhijklnqsz\86\AA\DFhijklnqs{\88\AA\CA\DFhijklmoru~\8C\B1\D4\DFhijklmoru~\8C\B2\DFhijklnpsv\7F\87\98\C7\DFhijklnptw\81\89\9A\CC\DFhijklmnpsw}\88\9E\DB\DFhijklmoquy\84\8D\A6\DFhijklmnoqsw{\87\91\AF\DFijklnpsw|\88\95\BC\DFijklmnprtx}\88\9A\CE\DFijklmoqty\7F\8A\A1\B7\DFijklmnoqru{\81\87\98\AC\C6\DFijklnprtw}\84\92\B7\CD\DFijkmnpqsux~\87\92\A8\C9\DFikmoqtx}\83\8A\91\A8\DFiklmoqruz\82\8E\94\B0\DFjkmnprsvy|\85\92\99\BD\DFjlnpqsuwy~\88\98\A0\CF\DFjlmoqtvxz\7F\89\93\A0\A9\DFjlnoqruwz\81\87\90\A9\B3\DFkmnprsvx{~\84\92\9D\B5\C1\DFhkmoqsuwy}\81\87\92\9C\C6\D4\DFhkmoqtvxz\7F\84\8A\91\A1\AF\DFhkmoruwz}\81\85\8E\94\AA\B8\DFhkmoqsvx{}\83\86\92\99\B6\C7\DFhkmoqsuwy}\7F\86\8A\98\A0\C8\DD\DFhlnprtvxz\7F\82\8A\8E\9F\A8\DFhloruxz}\81\84\8D\92\A9\B3\DFhlnpsvx{}\83\86\92\97\B5\C1\DFhlnqsvx}\7F\86\89\98\9D\C6\D4\DFhloqtxz\7F\81\89\8C\9F\A5\DFhloruy{\81\84\8D\90\A8\AF\B8\DFhloqsvy{}\83\86\92\96\B4\BD\C6\DFhmpsvx}\7F\86\89\97\9B\A0\C5\CF\DA\DFhjmprtxz\7F\81\89\8C\9E\A3\A8\DFhiloruz\80\83\8D\90\A2\A8\AD\B3\DFhilortvz|\83\86\92\95\9A\B4\BB\C2\DFhjmpswy}\80\86\89\97\9B\9F\C4\CC\D4\DD\DFhjmptxz\7F\82\89\8C\9E\A3\A8\DE\DFhimpsvz\81\84\8D\90\9E\A8\AD\B2\DFhimorv{~\83\86\92\95\9A\B3\B9\BF\C6\DFhjmorux}\80\86\89\97\9B\9F\C4\CB\D3\DC\DFhjmorux{\7F\83\89\8C\9E\A2\A7\DE\DFhjmorvz\81\84\8D\90\A7\AC\B1\DFhjmpsw{\7F\83\86\92\96\B3\B9\BF\C6\DFhjmprux}\81\86\89\97\9B\A0\C4\CB\D2\DA\DFhkmpqty\7F\84\89\8C\9E\A3\A8\DE\DFhlnqruz\81\85\8D\91\A7\AD\B3\DFinqsv|\83\86\92\96\B4\BB\C2\DFinqsux}\84\87\8B\97\9B\A0\C5\CD\D5\DE\DFimoqtvy\7F\85\8A\8E\9E\A3\A8\DE\DFimorux{\81\85\8D\91\A7\AD\B3\DFjnpsvx|\84\8B\92\97\B4\BB\C2\DFjnprtwy}\82\87\8D\98\9D\C5\CD\D6\DFmpqtxz\7F\84\8A\8F\9F\A5\DE\DFmpruy{\81\85\8D\92\A8\AE\B5\DFmprsvy{}\83\86\92\97\B4\BC\C4\DFmpsuwy}\7F\86\89\98\9E\C5\CE\D8\DFmortvxz~\80\89\8D\9F\A6\DE\DFmpsuwz~\81\83\8D\91\A8\AF\B9\DFmpsvx{}\83\86\92\97\B4\BD\C7\DFmpswx}\7F\86\89\98\9D\C5\CF\DB\DFmpruxy\7F\82\89\8C\9F\A5\DFloruyz|\81\84\8D\90\98\A8\AF\B7\DFlortw{}\83\86\91\94\97\B4\BC\C4\DFlosvy}\7F\86\89\97\9B\9F\C5\CE\D8\DFlortx{~\80\89\8C\9E\A2\A7\DE\DFkosuz\80\82\87\8D\90\9E\A7\AC\B1\DFkosvy|\83\85\92\95\9A\B3\B9\BF\C6\DFkoruwy}\81\86\88\97\9B\9F\C4\CB\D2\DA\DFkoruxz\7F\84\89\8C\9E\A2\A7\DE\DFkorvz\7F\82\8D\90\94\A7\AC\B1\DFkosw{}\83\86\91\94\97\B3\B9\BF\C5\DFkosx}\80\86\89\97\9A\9D\C4\CB\D2\DA\DFlpty\7F\82\89\8C\9E\A2\A6\DE\DFlptw{\81\84\8D\91\A7\AB\B0\B5\DFlptw|\83\86\92\96\B3\B8\BD\C2\DFlptx}\85\88\97\9C\AA\C4\CA\D0\D7\DE\DFlpuy\7F\86\8A\8D\9E\A3\A8\DD\DFmrvz\81\85\8D\90\A3\A9\AF\B6\DFmquy|\84\8B\92\95\9B\B4\BB\C2\DFmquy~\86\8A\97\9B\9F\C5\CD\D6\DFmpuy\7F\89\8D\9E\A3\A8\DE\DFnrv{\81\86\8E\93\A7\AC\B1\DFnrw|\84\8F\94\9A\B3\B9\BF\C6\DFnrx~\87\8F\98\9E\C4\CB\D3\DB\DFosy\7F\8A\90\9F\A5\DE\DFosz\81\87\8E\94\A8\AF\B8\DFpt{\84\92\98\B4\BC\C5\DFpt{\80\87\90\99\A0\C5\CF\DA\DFqv}\82\8A\90\9F\A7\DFrw~\84\8E\94\A8\B1\DFrw~\85\92\98\B5\C0\DFsx\80\88\98\9F\C6\D3\DFtz\82\8B\9F\A7\DFu{\84\8F\A8\B1\DFv}\86\93\9F\B5\C0\DFw\7F\89\99\A4\C6\D3\DFx\80\8C\A0\AC\DFy\80\8B\97\AA\B8\DFz\80\88\95\B6\C6\DF|\82\8A\9B\C7\DA\DF~\86\8F\A2\DF\7F\85\90\AB\C4\DF\81\87\94\B8\D0\DF\83\8A\9A\C9\DF\85\8C\A1\B7\DF\88\90\AB\C0\DF\8B\94\B8\CE\DF\8E\9A\AD\CA\DF\92\A1\AE\DF\96\AA\B8\DF\9C\B6\C6\DF\A3\C8\DC\DF\AB\DF\B6\DF\C4\DF\D9\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF~\DFj\DFi\DFh\DFh\DFh\DFh\DFhm\DFhj\DFhj\DFhi\DFhi\DFhi\B5\DFhil\DFhik\DFhik\DFhij\DFhijp\DFhik\DFhik\DFhik\DFhiko\DFhikm\DFhikm\DFhikm\DFhikm\DFhikm{\DFhikmq\DFhijln\DFhijlnt\DFhijlo\DFhijlou\DFhijlor\DFhijkmpu\DFhijkmpt\DFhijkmps\DFhijkmps\DFhijkmpt\DFhijklnru\DFhijklnrv\DFhijklnquy\DFhijkmptx\B3\DFhijkmosy\8F\DFhijklnqv{\A6\DFhijkmnqu|\93\DFhijkmorw~\9A\DFhijklmorw\7F\94\DFhijklnpsx\7F\85\B1\DFhijklnpsx~\85\A7\DFhijklmoqty\80\88\AD\DFhijklmoquz\81\8B\B4\DFhijklnprv|\84\8F\C1\DFijklnpsw}\86\93\9F\DFijklmnpsvz\81\8A\99\A5\DFijklmoqty\81\8C\A0\AC\DFijklmnoqsu{\83\90\AA\B8\DFijklnpsv|\86\95\B6\C6\DFijklmnprux~\89\9B\C8\DB\DFijklmoqtx|\81\8C\A2\DD\DFjklmoqrvz\82\90\AB\C1\DFjklnprsw|\84\94\B8\CF\DFjkmnpqsux}\84\8B\9B\C9\DFjlmoqtwz\7F\86\8D\A2\DFjlnoqruy}\81\86\8F\AB\C2\DFklnprsvy|\84\8C\94\B8\CF\DFkmnpqsuwy~\86\8A\99\A4\CA\DFkmoqtvxz\7F\8A\8F\A0\AC\DFkmoqruwz\81\87\8E\93\AA\B8\DFikmnprsvx{~\84\91\97\B6\C6\DFilnpqsuwy}\80\87\91\99\A0\C7\DA\DFhlnoqtvxz\7F\83\8A\91\9F\A6\DFhloqruxz}\81\84\8E\94\A8\B1\DFhlnprsvx{}\83\86\92\99\B5\BF\CE\DFhlnpqsuwy}\7F\86\89\98\9F\C6\D2\DFhmoqtvxz~\80\89\8D\9F\A7\DFhmoruwz~\81\84\8D\91\A8\B1\DFhmoqsvx{}\83\86\92\97\B5\C0\DFhmpsuwy}\7F\86\89\98\9D\C6\D3\DFhmoqtvxz\7F\82\89\8C\9F\A5\DFhjmpruwz}\81\84\8D\90\9C\A8\AF\B7\DFhjmpsvx{}\83\86\92\95\9A\B4\BC\C5\DFhjnqswx}\7F\86\89\97\9B\9F\C5\CF\DA\DFhjmprtxz~\80\89\8C\9E\A2\A7\DFhjmpruy{\81\83\8D\90\A7\AC\B1\DFhjmqsv{}\83\86\92\96\B3\B9\BF\C6\DFhjmqswz}\7F\86\89\97\9B\A0\C4\CB\D3\DB\DFhjmptx{\7F\81\89\8C\9E\A3\A8\DE\DFhimpsvz\81\83\8D\90\96\A7\AC\B2\DFhimptw{~\83\85\91\94\97\B4\BB\C2\DFhjnqtwz}\80\86\89\97\9A\9E\C5\CD\D6\DFhjmptx{\7F\83\89\8C\9E\A2\A6\DE\DFhjmpsvz\81\84\8D\90\96\A7\AC\B1\DFinqtw{\7F\83\86\91\94\97\B3\B8\BE\C4\DFinqtx}\81\86\89\97\9A\9E\C4\CA\D1\D8\DFimoquy\7F\84\89\8C\9E\A2\A6\DE\DFimorvz\81\85\8D\90\A7\AC\B1\DFjnpsw|\83\86\92\96\B3\B8\BE\C4\DFjnqsvy}\86\89\97\9B\9F\C4\CB\D2\D9\DFknprtx|\80\89\8D\9E\A3\A8\DE\DFnpruz\81\86\8D\91\A7\AC\B2\DFnpsvy|\84\8C\92\96\B3\B9\BF\C6\DFmprtwy}\82\87\8D\98\9D\C4\CB\D3\DC\DFmoqtwy\7F\84\8A\8F\9F\A4\AC\DE\DFloruy{\81\85\8E\93\A8\AE\B5\DFloqsvy{}\83\86\92\97\B4\BB\C3\DFknqsuwy}\80\86\89\98\9E\C5\CE\D7\DFknqtwy\7F\82\89\8D\9F\A6\DE\DFkoruxz~\81\84\8D\91\A8\B0\D2\DFkortvx{}\83\86\92\97\B4\BD\C7\DFkortwy}\7F\86\89\98\9D\C5\D0\DC\DFloqtwy\7F\82\89\8C\9F\A5\DFlpruxz}\81\84\8D\90\A8\AE\B5\DFlpsvy{}\83\86\92\96\B4\BC\C4\DFlortwy}\7F\86\89\97\9B\A0\C5\CE\D8\DFlortxz\7F\81\89\8C\9E\A3\A8\DE\DFknruz~\81\84\8D\90\A7\AC\B2\DFknrv{}\83\86\92\96\B4\BB\C2\DFknruwz}\7F\86\89\97\9B\9F\C5\CD\D6\DFknqux{\7F\82\89\8C\9E\A3\A8\DE\DFkosvz\81\84\8D\90\9B\A8\AD\B3\DFkosw{~\83\86\92\95\9A\B4\BA\C1\DFkorw}\80\86\89\97\9B\9F\C5\CC\D4\DD\DFkorwz\7F\83\89\8C\9E\A2\A7\DE\DFkosx{\81\84\8D\90\A1\A8\AD\B2\DFkptx|\83\86\92\96\B3\B9\BF\C6\DFkorv{~\86\89\97\9B\9F\C4\CB\D2\DA\DFkoruz\7F\86\8A\8D\9E\A3\A8\DE\DFkosv{\81\85\8D\91\A7\AC\B1\DFkosw|\84\8B\92\96\B3\B9\BF\C6\DFjnsx~\86\8A\97\9B\A0\C4\CB\D3\DB\DFjnty\80\8A\8F\9E\A3\A8\DE\DFjnsv{\82\8D\92\A8\AE\B4\DFjnrw|\84\92\97\B4\BB\C2\DFjnrx~\87\98\9E\C5\CD\D6\DFimrx\7F\8A\93\9F\A6\DE\DFinsz\82\8E\95\A8\AF\B8\DFins{\82\88\93\9B\B4\BD\C6\DFint}\87\98\A0\C5\CF\DA\DFint}\81\8B\A0\A9\DFimrw\81\88\90\A9\B3\DFilqw\83\88\93\9E\B5\C1\DFilqx\85\8A\99\A4\C6\D4\DFilqx\83\8A\91\A0\AC\DFilrz\87\8E\94\AA\B7\DFilrz\83\92\99\B6\C6\DFils{\82\94\9B\AB\C8\DB\DFils{\82\93\A0\A9\DFils|\84\96\A9\B3\DFilt~\86\9A\B5\C0\DFils}\88\9F\C6\D4\DFilqx\83\8C\A7\DFilpx\84\90\B0\DFikox\86\94\BD\DFikoy\89\9A\CF\DFhjmq{\8C\A1\B6\DFilp|\90\AB\BF\DFikow\81\96\B7\CC\DFilq\7F\97\C9\DFilq\80\98\B0\DFilpv\84\A0\BC\DFiknt\86\A3\C1\DFiknt\89\A8\D0\DFilpv\8D\B1\DFilpw\91\BA\DFiknsz\96\C7\DFiknsz\9C\D9\DFilpy\96\AD\DFilpv~\AD\DFikns}\AE\D0\DFikns\7F\AB\D1\DFilpv\81\A9\DFilpv\83\A9\DFilpv\85\AA\DFilpv\85\A2\DFilpv\80\8E\BF\DFilpv~\91\C5\DFilpv\7F\95\D0\DFjmqx\81\9B\DFjmqx\82\A2\DFjmqw\82\A8\C6\DFjmqx\83\A4\BF\DFilpv\80\8C\CB\DFilpv\80\8E\CC\DFilpv\7F\90\CF\DFilpv\7F\8C\9D\DFilpv\80\8E\A0\DFimry\84\93\A7\DFimry\85\95\AF\DFimry\86\98\BB\DFhkot|\8A\9F\CD\DFhkou~\8E\A6\DFhkou~\8D\AE\DFhjou~\8B\9D\BD\DFhkou~\8C\9F\CE\DFhjov\80\8F\A6\DFhjov\7F\91\AF\DFhjov\7F\8C\9F\BE\DFhjou~\8B\9F\CE\DFhjns{\86\97\AE\DFhils|\88\99\B2\DFhils}\89\9A\BC\DFhjnt\7F\8C\A0\CE\DFhjnu\81\8F\A6\DFhikov\83\93\AF\DFhikow\86\98\BC\DFhikox\88\9E\CE\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DFk\DFi\DFh\DFh\DFh\DFh\DFh\DFhj\DFhi\DFhi\DFhi\DFhi\DFhio\DFhik\DFhij\DFhij\DFhij\DFhijm\DFhijl\DFhijk\DFhijkx\DFhijkm\DFhijkl\DFhijkl\8A\DFhijklo\DFhijkm\DFhijklmt\DFhijkln\DFhijkln\96\DFhijkmo\DFhijklmo\B5\DFhijklnp\DFhijklnp|\DFhijklmoq\DFhijklmoqx\DFhijklnpr\81\DFhijklnps\DFhijkmnprt\DFhijkmoqtz\DFhijklnoqsu|\DFhijkmnpsv|\DFhijklnprtwz\DFhijklmoqtx|\DFhijlnoqruz\89\DFhijlnprtw|\90\DFhijklmoqsux}\84\DFhijkmoqtwz\7F\86\DFhijkmnpruy|\81\86\BD\DFhijkmnprtvy|\84\8C\DFhijkmnpsuwy}\84\88\AB\DFijklnoqtwy\7F\86\8B\A3\DFiklnoqtvz\81\86\8E\93\C8\DFiklnpsvy|\84\8C\93\99\D4\DFikmpqtwy}\81\87\8E\98\9F\DFikmoqtxz\7F\84\8A\8F\9F\A7\DFiklnqrvz\81\85\8E\93\A8\B1\DFijlnqsw{~\84\89\92\98\B5\BF\CD\DFjlnqsux}\81\86\8A\98\9F\C6\D3\DFjlmortvy\7F\84\8A\8E\9F\A7\DFjlnpsux{\81\85\8D\92\A8\B1\DFjknpsvx|\83\86\92\97\B4\BE\C9\DFjlnpruwy~\86\8A\98\9E\C6\D2\DFjloquxz\7F\89\8D\9F\A5\DFjlorvz~\82\8D\91\A8\AF\B8\DFjlnpsw{}\84\91\96\B4\BD\C6\DFjlnprtx}\7F\87\91\98\9D\C5\CF\DA\DFjlmprtx~\80\8A\91\9F\A5\DFkmoruy}\81\84\8E\94\A8\AF\B7\DFknqsvy|\83\86\92\99\B4\BC\C5\DFkmortwy~\86\89\98\9F\C5\CE\D9\DFkmortxz\7F\88\8B\90\9F\A7\DFkmoruz\81\86\8D\90\A8\B1\DFkmptvz}\84\8E\92\96\B5\C0\DFkmpruwy}\80\87\8E\97\9B\A0\C6\D3\DFkmoquxz\7F\83\8A\8F\9E\A3\A8\DFkmprvz\81\84\8E\93\A7\AD\B3\DFkmortw{~\83\86\92\98\B4\BB\C2\DFkmortx}\80\86\89\98\9E\C5\CD\D6\DFkmortwz\7F\83\8A\8E\9F\A6\DE\DFkmoruy}\81\84\8D\91\A8\B0\DFkmoqtvy}\83\86\92\97\B4\BD\C7\DFkmoruwy~\86\89\97\9C\BB\C7\D2\DFkmoqtxz\7F\89\8D\9F\A5\DFkmoruz\80\84\8D\91\A8\AE\B5\DFkmoqsv{~\84\92\97\B4\BC\C4\DFkmoqswz}\80\87\90\98\9D\C5\CE\D8\DFkmoqtx{\7F\83\8A\91\9F\A5\DE\DFkmoruz\81\84\8E\94\A8\AF\B7\DFkmoqsv{\7F\84\88\92\98\B4\BC\C4\DFkmoqsvy}\82\86\89\98\9F\C5\CE\D8\DFkmoqtx|\7F\84\8A\8D\9F\A7\DE\DFkmoruz\81\85\8D\91\A8\B1\DFkmoqsv{\80\84\89\92\96\B5\BF\CD\DFkmoqsvx}\84\87\8C\98\9D\C6\D2\DFkmoqtx{\7F\85\8A\8E\9F\A4\AC\DFkmoruz\81\85\8D\91\A8\AE\B5\DFkmoqsv{~\84\8C\92\97\B4\BB\C3\DFkmoqswz}\81\87\8D\98\9D\C5\CE\D8\DFkmoqtx{\7F\84\8A\8F\9F\A5\DE\DFkmoruz\81\85\8E\93\A8\AF\B7\DFknpsv{~\84\89\92\98\B4\BC\C5\DFkmoqsvy}\81\86\89\98\9E\C5\CE\D8\DFkmoqtx{\7F\84\8A\8E\9F\A6\DE\DFjloruz\81\85\8D\91\A8\B0\DFjlnpsvz}\83\86\92\97\B4\BE\C9\DFkmprtwy}\83\87\8B\98\9D\C5\D1\DE\DFkmoqtxz\7F\85\8A\8E\9F\A5\DFjloruz\81\85\8D\91\A8\AF\B7\DFjmpsv{~\84\8A\92\97\B4\BC\C4\DFjmpsvy}\80\86\8A\98\9D\C5\CE\D8\DFkmoqtx{\7F\83\8A\8E\9F\A5\DE\DFknqsuz\81\84\8D\92\A8\AF\B7\DFknpsvz}\83\86\92\97\B4\BC\C4\DFknqswy}\81\86\89\98\9E\C5\CE\D8\DFkmoqtxz\7F\84\8A\8D\9F\A6\DE\DFkmoruz\81\85\8D\91\A8\AF\B9\DFkmpsv{~\84\89\92\96\B4\BD\C6\DFkmpswz}\81\86\8A\97\9C\AF\C5\CF\DA\DFjmprux{\7F\83\8A\8E\9F\A4\AC\DFjmpruz\81\84\8D\91\A8\AE\B5\DFjmortw{~\83\86\92\97\B4\BB\C3\DFjmosvy}\81\86\89\98\9D\C5\CD\D6\DFjmortx|\7F\84\8A\8E\9F\A5\DE\DFjmoruz\81\85\8D\91\A8\AF\B7\DFjmptvz}\83\86\92\96\B4\BC\C5\DFjmpswy}\83\87\8B\98\9D\C5\CE\D9\DFjmprux{\7F\85\8A\8E\9F\A5\DFjnqsvz\81\85\8D\91\A8\AE\B5\DFjnqsw{~\84\8A\92\96\B4\BB\C3\DFjnqsw}\81\87\8C\98\9D\C5\CE\D8\DFkorty\7F\84\8A\8E\9F\A4\AC\DE\DFkosuz\81\84\8D\92\A8\AE\B5\DFkosv|\83\86\92\97\B4\BB\C3\DFkoswz~\86\89\98\9E\C5\CE\D8\DFkorux{\80\89\8D\9F\A6\DE\DFkosvz\81\87\8D\91\A8\AF\B9\DFkosw{\7F\84\92\97\B4\BD\C7\DFkotx}\83\88\98\9D\C5\CF\DA\DFlpuy\7F\85\8B\9F\A5\DFlqvz\81\85\8E\94\A8\AF\B7\DFlqw|\84\8B\93\99\B4\BC\C4\DFkotx}\86\8A\98\9F\C5\CE\D8\DFknsy\7F\8A\8F\9F\A7\DE\DFkou{\81\87\8E\93\A8\B1\DFkou|\84\92\98\B5\C0\DFkou{\81\87\91\98\9E\C6\D3\DFkpv|\82\8A\91\9F\A6\DFlpw~\84\8E\94\A8\B0\DFlqx\7F\86\92\98\B4\BE\C9\DFlqy\80\88\98\9F\C5\D1\DE\DFlrz\81\8B\9F\A7\DFms|\84\8F\A8\B1\DFms}\86\94\B5\C0\DFmt\7F\89\9A\BB\C7\D4\DFmu\81\8C\A1\B1\DFnv\83\8F\AA\BA\DFnw\84\94\B7\CA\DFnw\82\98\A5\C8\DFoy\87\A1\B2\DFoz\88\A0\AE\DFp|\8B\A5\B8\CB\DFp}\8D\A8\C8\DFq\7F\90\AD\DFq\80\93\B6\DFr\83\99\C3\DFs\86\9F\D5\DFt\89\A6\DFu\8C\A8\DD\DFv\8F\A2\C3\DFw\92\A6\D1\DFx\95\A9\DFy\99\B1\DF{\9F\BD\DF}\A6\CE\DF\7F\AF\DFo\83\BA\DFo\85\C8\DFo\82\92\DE\DFo\81\90\DFm\85\96\DFm\84\98\DFl\81\9D\DFl\82\A4\DFl\84\AE\DFk\88\BB\DFk\8C\CD\DFk\8F\DFk\93\DFk\96\DFj|\99\DFjs\9D\DFjs\A0\DFjs\A4\DFjt\AC\DFjt\B5\DFju\BF\DFju\CE\DFjt\DFjs\D3\DFjr\B6\DFjq\B0\DFjq\83\B5\DFjp\81\D2\DFjp\83\A8\DFjp\83\A8\DFjo\83\AB\DFjo\84\B1\DFjo\86\BB\DFjo\87\C8\DFimx\93\DD\DFimx\95\DFimw\99\DFimv\9E\DFimu\A2\DFimu\A9\DFimt\8C\BE\DFimt\89\C9\DFhkp~\DA\DFhjox\94\DFhjox\91\DFimt\8B\DFhjox\93\DFhjox\95\DFhjnv\95\DFilr~\A1\DFhjnv\86\AE\DFhjnv\86\B2\DFhjnv\87\BB\DFhjnv\87\C8\DFhjmt\83\D7\DFhjmt\83\B5\DFhjmt\82\A1\DFhjmt\82\A0\DFhjmt\82\A2\DFhjmt\82\A8\DFhjms\80\9E\DE\DFhjms\80\9E\D8\DFhjmr~\9D\DFhjmq|\93\D1\DFhjmq{\93\CD\DFhjmq{\91\CF\DFhikns\7F\9D\DFhikns\7F\99\DFhilpw\89\B6\DFhikns\80\9C\DA\DFhikns\7F\9F\DFhiknrz\91\BE\DFhikns{\93\C2\DFhijmqw\89\C0\DFhijmqw\87\B2\DFhijlpv\80\9D\DFhikns{\94\D4\DFhikns{\8F\CB\DFhiknsz\86\A9\DFhikmqx\83\A8\DFhikmqw\81\9C\D2\DFhikmqw\80\8F\C5\DFhikmqw\81\8F\CC\DFhikmqw\81\8F\C0\DFhikmpv\7F\91\C4\DFhikmot|\88\99\D5\DFhijlnry\84\96\B4\DFhijlnpv\80\8E\A6\DFhijlos{\86\95\B0\DFhijlnqw\80\8F\A2\C0\DFhijlory\83\94\A8\D0\DFhijlory\83\92\A7\DFhijlory\84\94\AF\DFhijknqt}\88\99\BB\DFhijlosz\84\96\B5\D6\DFhijloru~\8D\A6\DFhijkmptx\83\92\AF\DFhijkmptw\81\91\AF\D1\DFhijlnqux\82\8F\A1\CF\DFhijlnquy\84\92\A6\DFijlnrv{\87\96\AF\DFijlnqu{\86\97\BB\DFijlnquz\7F\8D\9F\CD\DFijlnpty\80\8F\A5\DFijkmosx~\83\94\AE\DFijkmoqu|\84\98\BB\DFijkmorv|\85\8B\9F\CD\DFikmorv{\81\8B\A6\DFiklorv|\83\8E\96\B1\DFikmpsw}\85\93\9D\BE\DFikmpsx\7F\88\99\A3\D0\DFjlmpruz\81\8B\A0\AB\DFjlnqsv{\83\8F\A9\B5\DFjlnqtw}\86\94\B6\C5\DFjmorux~\88\9A\BE\CE\DFilnpty\80\8C\A1\B2\DFjmoruz\82\8F\AA\BA\DFjmoqtw|\85\94\B7\CA\DFjmoqtx}\88\9A\C8\DFjmoquy\7F\8B\A1\B7\DFjmorvz\81\88\91\AB\C0\DFjmpsw|\84\94\B7\CD\DFjmpsw}\87\99\A8\CA\DFjnqty\7F\89\8F\A1\B1\DFjnru{\81\87\8F\A2\B0\DFjnrux}\84\92\99\B7\CA\DFkoswz\7F\87\91\99\A1\C8\DE\DFkotx|\82\8A\91\A0\A9\DFkpuz\82\8E\94\A9\B4\DFkpv{\80\87\92\99\B5\C2\DFkpvy}\84\8C\98\9F\C6\D5\DFkpvy\7F\86\8E\9F\A7\DFlqw{\81\85\8F\A9\B2\DFlry|\84\8C\95\B5\C0\DFlry~\86\8A\9A\B8\C7\D5\DFlqw\7F\89\8E\A1\B1\DFlpv\7F\83\8E\93\AA\BA\DFlov\7F\84\90\95\B7\CA\DFlpw\81\87\90\98\9E\C8\DE\DFlpw\81\8A\90\9F\A6\DFlqx\83\8E\94\A8\B0\DFlqy\85\92\98\B4\BE\C9\DFlqz\85\98\9F\C6\D2\DFlr{\86\95\A0\A8\DFls|\87\96\A9\B2\DFls~\8A\9A\B5\C0\DFmt\7F\8C\9E\C6\D3\DFmu\81\8F\A5\DFmv\83\93\AE\DFmw\86\98\BB\DFnx\89\9E\CD\DFny\8C\A6\DFnz\90\AF\DFny\80\95\BC\DFo}\9B\CF\DFo|\84\A2\DFoz\83\AC\DFoz\86\B8\D4\DFp|\89\CA\DFq~\8C\DFq~\90\DFq\7F\95\DFr\81\9B\DFr\83\A2\DFr\85\AC\DFs\88\B9\D6\DFt\8B\CB\DFu\8E\DFv\93\DFv\97\DFw\99\DFw\8E\AF\DFx\90\B7\DFy\92\C2\DFz\94\D5\DF{\97\DF}\9B\DF~\9F\DF\7F\A5\DF\80\AC\DF\82\B7\DF\84\C4\DFz\D2\DFv\87\DFo\89\DFo\8C\DFo\8F\DFp\93\DFo\97\DFn\9C\DFn\A3\DFn\AB\DFn\B6\DFn\C3\DFm\A9\DFl\AF\DFl\B7\DFl\BB\DFl\BF\DFl\C5\DFk~\D7\DFk}\DFk|\DFjv\9B\DFjv\9F\DFjw\A4\DFjx\AB\DFky\B3\DFk{\BF\DFkv\99\D9\DFkv\A6\DFkw\A7\DFkw\BB\DFkw\DFkx\DFjr\96\DFjr\9A\DFjp\7F\A5\DFjp\81\AD\DFjo\83\9E\DFjp\85\A0\D0\DFjp\88\A5\D7\DFjp\89\A7\DD\DFjq\8D\AE\DFjq\8F\B7\DFjr\94\C4\DFjq\87\A5\DB\DFjq\88\AB\DFjq\88\B6\DFjpz\90\C3\DFimw\97\D6\DFimw\98\DFimx\9C\DFimx\A0\DFimy\A7\DFimx\AD\DFimv\85\BC\DFiny\8C\C6\DFimv\87\B4\DFimw\89\B8\DFimv\8A\CA\DFimt\89\DFimt\8C\C1\DFilr\7F\95\DFilr\80\99\DD\DFhjow\98\DC\DFhjnv\86\A4\DFhkq~\AB\DFhjmu\88\B6\DFhjmu\89\C4\DFhjmu\8B\D7\DFhjmu\8C\DFhilr}\96\DFhilp{\9A\DFhilp{\9F\DFhjmr~\A8\DFhjmr\80\B2\DFhjmr\80\BE\DFhjnt\84\D2\DFhikns\82\9B\DFhikou\87\A4\DFhikou\87\A3\DFhikou\87\A4\DFhiknt\87\A9\DFhikmqx\8F\B6\DFhijlqx\90\C1\DFhijmrz\94\D3\DFhijmrz\95\DFhijlot}\9C\DFhijlnt~\9F\DFhijknt\7F\A5\DFhijknry\85\B1\DFhijkmpw\84\B8\DFhijkmpx\86\C5\DFhijkmqy\89\D9\DFhijklorz\8B\DFhijklos|\90\DFhijklns}\91\DE\DFhijklmqt\7F\95\B5\DFhijklmpu\81\98\B3\DFhijklmnrv\83\9B\B7\DFhijklnqw\86\A0\C1\DFhijkmnpv{\89\A5\D1\DFhijkmory\8C\AD\DFhijklmoqw|\90\B6\DFhijkmnpt|\95\C3\DFhijkmnpqu}\9B\D6\DFhijklmoqt|\82\A2\DFhijklnoqrv\81\A2\BA\DFhijklnprsx\84\B0\CD\DFhijkmoqsuz\87\B7\D7\DFhijkmoqtv{\8A\A7\DFhiklnpruw|\8A\93\DFhikmnprsvx~\8D\96\DFhikmoqsuwy\7F\8F\9B\DFhijlnoqtwy\80\91\A1\B1\DFhijlnpruxz~\85\98\AB\BB\DFijlnpsvy{}\85\9A\B7\C9\DFhjlmoqtwy}\7F\88\A0\C8\DE\DFhjlmoqtxz\7F\82\8C\A8\DFhjkmoruz\80\83\8F\B1\DFiknpsw{~\83\86\94\BF\DFikmoqsvy}\80\86\89\9A\CC\DFhjloqty\7F\83\89\8C\A1\B4\DFikloruz\81\84\8D\91\AB\BD\DFikmpsv|\83\86\92\96\B7\CB\DFikmprux}\86\89\97\9C\AB\C9\DFikmprux|\80\89\8D\9E\A3\A9\DFikmoruz\81\87\8D\91\A8\AE\B5\DFikmortw|\84\90\94\99\B4\BB\C3\DFikmosvy}\84\89\98\9D\C5\CD\D6\DFikmorty\7F\85\8B\9F\A5\DE\DFikmoruz\81\85\8E\94\A8\AF\B7\DFiknptv{\80\84\8B\93\9A\B4\BC\C4\DFikmprvy}\85\89\98\9F\C5\CE\D8\DFikmoqux{\7F\87\8B\99\A1\A9\DE\DFikmorvz\81\86\8E\93\A8\B1\DFikmpsw{\7F\84\8D\93\98\B5\C0\DFikmpsvz}\82\87\8E\98\9E\C6\D3\DFikmprty\7F\84\8A\8F\9F\A6\DFikmpsu{\81\85\8E\93\A8\B0\DFikmoruw|\83\86\92\98\B4\BD\C7\DFikmoruwz\7F\86\8A\98\9F\C5\D0\DC\DFikmorux{\80\89\8D\9F\A6\DFikmoruz\82\8D\92\A8\B1\DFikmpsw{\7F\85\92\97\B4\BE\C9\DFikmpsw|\7F\87\98\9D\C6\D2\DFikmoquy\7F\84\8B\9F\A5\DFikmorvz\81\85\8E\96\A8\AF\B8\DFikmortw|\83\86\93\9C\B4\BC\C5\DFikmortx}\85\89\99\A2\C5\CF\DA\DFikmorty\7F\87\8B\94\A0\AA\DFijloruz\81\86\8D\92\A9\B4\DFijlnpsv{\84\8E\93\98\B5\C2\DFijlnqtwz~\86\8B\98\9E\C7\D7\DFikmoqux{\80\8A\90\9F\A5\DFikmorvz\82\8E\94\A8\AF\B8\DFikmortw{\7F\85\92\98\B4\BD\C6\DFikmortx}\82\88\98\9F\C5\CF\DA\DFikmoruy\7F\84\8B\9F\A7\DFikloruz\81\85\8E\95\A8\B1\DFikmpsv|\83\86\93\9B\B5\BF\CD\DFikmprux}\86\8A\99\A1\C6\D2\DFikmoqux|\80\89\8D\A0\A9\DFikmorvz\81\88\8E\93\A9\B4\DFikmnqsw|\84\92\97\B5\C2\DFikmortx}\84\89\98\9E\C6\D5\DFikmorty\7F\85\8B\9F\A5\DFikmoruz\81\85\8E\95\A8\AF\B8\DFikmpsv{\81\85\93\9B\B4\BD\C6\DFikmpruwz~\86\8A\98\A0\C5\CF\DA\DFikmoqux{\7F\89\8E\A0\A9\DFikmorvz\81\87\8E\93\A9\B4\DFikmortw{\7F\84\90\95\B5\C1\DFjlnqsux}\82\87\90\98\9E\C6\D5\DFjlnpsuy\7F\84\8A\90\9F\A6\DFjlnpsuy}\81\85\8E\94\A8\B0\DFjlnpsvy|\83\86\92\98\B4\BD\C7\DFjlnpruwy~\86\8A\98\9F\C5\D0\DC\DFjloquxz\7F\89\8D\9F\A7\DFkmorvz\80\85\8D\92\A8\B1\DFkmpsw{~\84\92\97\B5\C0\DFkmpsvy}\80\87\92\98\9E\C6\D3\DFjlnqty\7F\83\8A\91\9F\A5\DFjlnqsuz\81\84\8E\94\A8\AF\B8\DFjlnqsv{\81\84\89\93\9A\B4\BC\C5\DFjmoswz~\86\89\98\9F\C5\CF\DA\DFjmortx{\7F\87\8A\8E\9F\A7\DFjmoruz\81\86\8D\91\A9\B3\DFjnptw{\7F\84\8D\92\97\B5\C0\DFjnprvy}\82\87\8E\98\9D\C6\D3\DFjnprux|\7F\84\8A\8F\9F\A5\DFjorvz\81\85\8E\93\A8\AF\B7\DFjoqsw|\83\86\92\98\B4\BC\C5\DFjortx}\83\87\8C\98\9F\C5\CE\D8\DFjnqty\7F\85\8A\8E\9F\A6\DE\DFjmruz\81\85\8D\92\A8\B0\DFjnruw|\84\8B\92\97\B4\BE\C9\DFjnswz\7F\86\8A\98\9E\C5\D1\DE\DFjntx{\80\8A\8F\9F\A5\DFjnuz\82\8D\92\A8\AF\B8\DFjnux{\7F\85\92\97\B4\BC\C5\DFjnvy}\81\88\98\9E\C5\CF\DA\DFjmqx}\80\8A\93\9F\A6\DFjmqy|\81\85\8E\96\A8\B0\DE\DFjmqz}\83\86\93\9C\B4\BD\C7\DFjnr{~\86\8A\99\A2\C5\D0\DC\DFjnr|\80\89\8D\A0\AA\DFjns~\82\8D\91\A9\B4\DFjns\7F\84\8D\92\97\B5\C2\DFkot\81\87\8E\98\9D\C6\D5\DFkou\82\8A\90\9F\A5\DFkpv\85\8E\93\A8\AF\B8\DFkpw\87\92\98\B4\BC\C5\DFkpx\8A\98\9F\C5\CF\DA\DFkpx\8D\9F\A7\DFjns{\92\A8\B1\DFjns|\96\B4\BE\C9\DFkpv~\9D\C6\D2\DFkot\80\A4\DFkpv\82\AE\DFkpv\84\BB\DFkpw\87\CD\DFkpw\86\90\DFkpx\85\91\DFkqy\86\95\DFkqz\86\9A\DFkr{\86\A1\BA\DFls}\89\AB\C1\DFlt~\8B\B7\CE\DFlt\80\8E\C4\DE\DFlt\82\90\C2\DFlt\83\93\C8\DFls{\88\99\D4\DFls{\8A\9E\DFlt|\8E\A6\DFmu~\92\AF\DFmu\7F\96\BC\DFmv\81\9D\CE\DFmv\82\A4\DFmv\84\AE\DFmv\87\BB\DFnx\8A\CD\DFny\8D\DFo{\91\DFo{\96\DFo|\9C\DFo}\A4\DFp\80\AE\DFp\80\BA\DFq\83\CD\DFq\84\C8\DFr\87\BB\DFr\87\AB\DFs\8A\B1\DFt\8E\B8\DFt\89\B5\DFt\87\B1\DFu\88\B2\DFv\8A\B6\DFw\8C\BF\DFx\8E\CB\DFy\91\DFy\94\DFz\98\DF{\9D\DF}\A4\DF~\AB\DF\81\B6\DF\83\C4\DF\87\D7\DF\8B\DF\91\DF\97\DF\9D\DF\A4\DF\AE\DFo\B3\DFn\8F\DE\DFl\8D\DFl\8C\DFl\8E\DFl\93\DFk\95\DFk\96\DFk\98\DFk\9D\DFj\AE\DFiy\BE\DFir\B8\DFiq\B6\DFio\C6\DFio\A7\DFio\AE\DFio\BA\DFio\A4\DFin\CE\DFhkx\B5\DFhkt\BD\DFhks\C7\DFhjp\AB\DFhjp\AD\DFhjn~\DFhjn\7F\DFhilv\AB\DFhilt\B3\DFhilt\BF\DFhilq}\D3\DFhikp~\DB\DFhikp\80\DFhijms\82\BA\DFhijms\84\C4\DFhijms\86\D2\DFhijlpv\89\BE\DFhijlpv\8B\BA\DFhijlpw\8E\C0\DFhijknv\94\CA\DFhijknu\95\D1\DFhijkmrz\9C\DFhijkmr{\A3\DFhijklot}\AA\DFhijklnt~\B5\DFhijklnt\80\C4\DFhijklmpv\82\CE\DFijklnry\85\D7\DFijklmou\86\AF\DFijklmosz\8A\B7\DFijklmosz\8D\BC\DFhijklmnpt|\91\C5\DFhjklmnpt}\96\D1\DFhjklmnoqv\80\9C\DFhjklmoqv\81\A4\DFhjklmnoprw\83\AD\DFhklmnpsx\86\BA\DFhiklmnopqtz\89\CC\DFhiklmoqsv|\8C\DFhiklmnoprv|\90\DFhilmnprsw~\95\DFhilmnopqstx\80\9B\DFhikmoqrtuy\81\A2\DFhijmnopruw{\84\AB\DFhijmnprsvw|\86\AF\CE\DFhijnopqstwx}\89\B4\D5\DFhijlnoqrtuxy\7F\8C\BA\DFhijkopqruvyz|\82\90\C3\DFhijkoprsvw{|\84\95\D0\DFhijkpqstwx}\7F\87\95\A4\DFhijlpqstuxy~\80\8A\92\A3\DFhijlpruvyz{\80\82\87\8E\95\AC\CE\DFhijlqrsvw{|\83\85\93\9B\B9\D2\DFhijkmqstwx|}~\86\88\98\A0\CA\DFhijkmrtuxy~\7F\80\89\8C\A0\A9\DFhijkmsuvyz{\80\81\82\84\8D\90\95\A9\B4\DFhijkmosvw{|\82\83\84\85\91\94\97\B5\C1\DFhijkmptwx|}~\86\88\8D\97\9A\9E\C6\D5\DFhijklnuxy~\7F\80\89\8B\8D\9E\A2\A6\DFijklouyz{\80\81\82\84\8D\8F\91\A7\AC\B1\DFijklnqv{|\83\84\85\91\93\96\B3\B8\BD\C3\DFijkmpw|}~\85\86\87\88\8B\97\9A\9D\C4\CB\D2\D9\DFijkmpx~\7F\80\89\8A\8B\8C\9E\A1\A4\A7\DE\DFijklnrx{\80\81\82\84\8D\8F\91\A7\AA\AE\B2\DFjkmnrx|\83\84\85\91\93\95\97\B3\B7\BB\BF\C4\DFjkmoty}\81\86\87\88\8B\97\99\9B\9D\C4\C9\CE\D3\D8\DE\DFjkmouy\7F\83\89\8A\8B\8C\9E\A0\A3\A6\DD\DFjklov{\81\84\8D\8E\90\92\A7\AA\AD\B0\B3\DFkmp|\83\86\91\93\95\97\B3\B6\B9\BC\BF\C3\DFkmp}\82\86\89\97\99\9B\9D\C3\C7\CB\CF\D3\D7\DB\DFkmp|\7F\83\89\8C\9E\A0\A2\A4\A6\DD\DFlou}\81\84\8D\90\93\A7\AA\AD\B0\B3\DFlo{\83\86\91\94\97\B3\B6\B9\BC\BF\C2\C8\DFmrz\7F\86\89\97\9A\9D\C3\C6\C9\CC\CF\D2\D6\DA\DE\DFmtz\80\89\8C\9E\A1\A4\A7\DD\DFny~\82\8D\90\93\A7\AA\AD\B0\B3\DFow|\84\89\91\94\97\B3\B6\BA\BE\C2\DFrx}\84\87\8B\97\9A\9D\C4\C8\CC\D0\D5\DA\DFry\7F\84\89\8C\9E\A1\A4\A7\DD\DFrx|\81\84\8D\90\98\A7\AA\AD\B0\B4\DFquz}\83\86\91\94\97\B3\B7\BB\BF\C3\DFquy}\82\86\89\97\9A\9D\C4\C9\CE\D3\D8\DD\DFquy\7F\84\89\8C\9E\A2\A6\DD\DFquz\81\84\8D\90\A7\AB\AF\B3\DFrv|\83\86\92\95\9A\B3\B8\BD\C2\DFqtx}\85\88\97\9B\9F\C4\C9\CF\D5\DC\DFquy\7F\86\8A\8D\9E\A2\A7\DD\DFpuz\81\85\8D\90\9F\A8\AD\B2\DFpv{\7F\84\8A\92\95\9A\B3\B9\BF\C5\DFpwz}\81\86\8A\97\9B\9F\C4\CB\D2\DA\DFpx{\7F\84\8A\8E\9E\A2\A7\DE\DFoy|\81\84\8D\91\A7\AC\B1\DFoz}\83\86\92\97\B3\B8\BE\C4\DFo|\7F\86\89\98\9D\C4\CB\D2\DA\DFp}\80\89\8C\9F\A5\DE\DFp\7F\82\8D\91\A8\AF\B7\DFp\80\84\88\92\96\B4\BC\C4\DFq\82\86\89\97\9C\AC\C5\CE\D8\DFq\84\8A\8D\9E\A3\A9\DE\DFq\85\8D\91\A8\AE\B5\DFq\88\92\96\B4\BB\C3\DFr\8B\97\9C\AD\C5\CD\D6\DFr\8E\9E\A3\A9\DE\DFr\84\9B\A8\AE\B5\DFr\82\9B\B4\BB\C3\DFs\82\A1\C5\CD\D6\DFt\83\A8\DE\DFu\84\B2\DFu\85\BF\DFv\87\D2\DFw\89\DFx\8B\DFz\8D\DF{\90\DF|\93\DF~\98\DF\7F\9C\DF\81\A3\DF\83\AB\DF\86\B6\DF\89\C3\DF\8D\D6\DFz\91\DFu\94\DFt\99\DFs\9F\DFr\A7\DFr\B1\DFr\BF\DFr\D2\DFr\DFs\DFq\DFp\DFp\DFp\DFo\DFn\DFn\DFn\DFn\DFn\DFm\DFm\CF\DFm\A0\DFm\95\DFm\8F\DFl\86\DFl\87\DFl\85\DFl\83\DFl\82\DFlz\AB\DFlz\A8\DFl{\AA\DFl{\AD\DFl{\AF\DFl{\BD\DFm~\C0\DFl}\D7\DFl~\DFl\7F\C6\DFl~\C6\DFl|\DFlw\8E\DFlv\8F\DFks\91\DFkt\95\DFku\9B\DFku\A1\DFkv\A8\DFkv\B3\DFkv\C1\DFkw\D4\DFkx\DFkw\DFkw\D3\DFkw\87\DFkv\86\DFkv\88\DFkv\8A\DFkv\8C\DFkv\8F\DFjq\8B\DFjq\88\A3\DFjp\85\A2\DFjp\85\AA\DFjq\88\B4\DFjq\89\C0\DFjq\8A\D3\DFjq\8C\DFjq\8A\DFjq\8A\DFjq\8A\DFjq\8B\DFjq\86\DA\DFjq\83\D9\DFiny\B3\DFiny\B3\DFinz\B8\DFjp}\C7\DFjp~\D1\DFjp\7F\D5\DFimw\8E\DFimv\8D\DFjo}\A1\DFimv\8E\DFjnx\94\DFjoy\97\DFimv\8E\DFimw\91\D5\DFimw\91\D1\DFilr\7F\AB\DFimu\8F\DD\DFimt\82\B4\DFimt\82\B1\DFims\81\AD\DFimt\83\B3\DFimt\84\B8\DFimt\86\C2\DFimt\88\CF\DFimt\8B\DFilq{\91\DFilqz\95\DFilr|\9A\DFilr|\A0\DFilr}\A7\DFilr~\B1\DFhjnu\82\BF\DFhjnu\82\D1\DFhkpx\87\DFhjmt\84\CB\DFhjms}\90\DFhjms|\8E\DFhjmt~\92\DFhilq|\93\D9\DFhilpy\8D\B2\DFhilpy\88\A4\DFhikow\84\A7\DFhikow\85\B0\DFhijmqz\89\BE\DFhjmr|\8C\D0\DFhjmr|\8F\DFhikot\7F\94\DFhikou\81\98\DFhjlpv\83\9E\DFhjlpv\84\A5\DFikmqw\86\AF\DFikns{\8C\BD\DFikmry\8B\CE\DFikmrz\8E\DFikmr{\92\DFiknt}\97\DFiknt\7F\9E\DFiknry\84\A6\DFiknqw\83\AF\DFhjmpx\86\BC\DFhjmpx\87\B3\DFhknqz\8B\C0\DFhknr{\8D\C4\DFhknr{\8B\9C\DFhknrv\80\96\B1\DFhjmpu\81\97\AD\DFhjmpu\83\9A\B2\DFhjmqv\85\9D\BC\DFhjnrx\88\A3\CE\DFhjmqv{\8C\AB\DFhjnrw|\90\B5\DFikosx}\95\C2\DFikotz\7F\9B\D4\DFikpu{\81\A2\DFikpv|\83\AC\DFikpu|\85\B9\DFikpu{\83\8A\CB\DFiknry\81\8B\BD\DFiknsz\83\8F\C9\DFhjms{\86\94\DC\DFhjmt|\88\9A\BD\DFhjmu}\86\90\A1\B2\DFhknv~\86\91\AA\BA\DFiknw\80\89\95\B7\CA\DFikntx\81\8A\9B\C8\DFilpy\83\8D\A2\DFilpz\85\91\AB\C3\DFilp|\88\95\B8\D0\DFilos~\8B\9B\C9\DFikmqy\80\8E\A2\DFiknr\82\92\AC\D2\DFikns\84\96\B8\D1\DFikot\87\9D\CA\DFikou\8B\A4\DFikot{\8F\AE\DFikpv\80\94\BA\DFikorx\85\99\A8\CE\DFilqx\84\A1\B1\DFilrz\87\AA\BA\DFikns|\8B\B7\C9\DFilot}\8D\C8\DE\DFilnt|\84\96\DFilou~\87\9B\DFilov\7F\88\9C\DFilow\81\8A\A1\DFilox\83\8D\A8\DFilpy\81\90\B1\DFilp{\88\95\BE\DFilq|\84\9A\D0\DFilq{\81\92\A3\DFilps\80\88\9C\AF\DFilos\82\89\9D\B9\D6\DFilpt\84\8C\A2\CB\DFilpu\86\8E\A8\DFilpv\89\92\B1\DFilqw\8B\95\BD\DFilqx\8E\9A\B9\DFilqy\8F\A1\B1\DFilpu{\96\AB\BC\DFilpu|\97\B7\CA\DFilpu~\9E\C8\DFilpu\80\A1\DFilpv\82\A0\DFilqx\84\A2\DFilqx\87\AA\DFilqy\8A\A9\DFilq{\8E\9F\DFilpv~\93\A4\DFilqx\80\99\A9\DFilqw\81\A0\AE\DFimry\83\AA\BA\DFimry\86\B6\C9\DFimsz\88\C7\DE\DFjnt{\8C\DFjnt|\90\DE\DFjnu~\94\DFjov\7F\9A\DFjov\81\A2\DFjns|\86\AB\D2\DFjnrz\86\B8\D6\DFjns{\89\CA\DFjmr{\8C\D4\DFjms}\90\D8\DFjms~\95\DFimt\80\9B\DFimu\82\A2\DFimu\84\AB\DFimsy\87\B3\D2\DFimsy\8A\B7\D8\DFimrz\8D\BD\DFimr{\91\C6\DFjow~\96\D1\DFjou\7F\9C\DFjou\80\A4\DFjou\82\AD\DFjou\85\BA\DFjou\88\CC\DFjov\8B\DFjov\8F\DFjow\93\DFilrz\9A\DFilrz\A0\B6\DFilr{\9F\B1\DFjnv\7F\B7\CF\DFimt\7F\A5\CA\DFimt\81\A8\DFimt\81\9C\DFimt\82\9E\DFjnv\86\A9\DFjnv\86\97\DFjox\8A\9D\DFjox\8B\9D\DC\DFjox\8C\9F\DFjox\8C\A5\DFilq|\95\B0\DFilr~\9A\BD\DFilr~\9C\CE\DFims\80\A2\DFimt\82\A3\DFimt\82\A2\DFimu\84\A6\DFimv\86\AD\DFimv\87\B5\DFims{\92\CD\DFimrz\8F\CC\DFimr{\92\C7\DFimr|\95\CC\DFimr~\9A\D6\DFims\80\A1\DFims\81\A5\DFilr\83\A8\DFilqy\87\B0\DFilr|\8B\B8\DFilqx\8D\BB\DFilqx\91\C4\DFilrz\96\D0\DFilrz\9C\DFilr{\A3\DFilr|\AC\DFilpw\81\BA\DFilqy\84\CC\DFhkov\82\AC\DFilpx\85\AD\DFilqy\87\AF\DFilqz\8A\B3\DFilq{\8E\BA\DFilr|\92\C3\DFilr~\96\CD\DFilqy\83\9D\DFilqx\83\A4\DFilpw\84\AE\DFilpx\87\BB\DFjnu\80\8D\CD\DFjnu~\8E\DFjnt}\91\DFjns}\96\DFkpx\82\9C\DFkou\81\A4\DFkot\81\AD\DFkou\84\BA\DFknt\83\93\CC\DFlqx\8B\DFlpw\89\9A\DFlpw\8A\9C\DFlpx\8C\9F\DFlpy\8E\A6\DFmq{\94\B0\DFmq{\8F\BB\DFlpx\81\A2\CE\DFlq{\85\AB\DFlqz\85\B1\DFlr|\88\B5\DFlr{\89\B5\DFlry\8C\BA\DFls{\90\C3\DFlt}\95\D0\DFlt|\94\A8\DFkt|\94\A8\DFku}\97\B0\DFku}\9A\BB\DFku~\9D\CD\DFku}\8E\BF\DFku}\88\B6\DFku~\8A\C2\DFkv\80\8C\BD\DFjs\81\8E\BF\DFkx\84\93\CA\DFkw\87\97\D3\DFjq\80\8C\9E\DFjq\80\8E\A5\DFjq\80\91\AE\DFjq\81\96\BB\DFjq\83\9C\CD\DFjq\85\A4\DFjr\87\AD\DFjr\8A\BA\DFjr\8C\CC\DFinz\92\DFjq\92\DFjr\98\DFimx\A1\DFimw\A8\DFjny\B2\DFjo{\C0\DFjo{\D2\DFjny\AB\DFjo{\B2\DFjo{\9C\DFimy\96\DFilq~\A1\DFilr\80\A4\DFilr\81\A7\DFilr\83\AC\DFims\85\B4\DFimt\87\BD\DFimt\8A\CB\DFimu\8D\DFimv\91\DFimu\95\DFims|\9B\DFims|\A1\DFims|\A9\DFilr}\B3\DFilr~\C0\DFhjnu\81\D4\DFhjnu\82\DFilr\82\DFikpx\87\DFilr|\8B\DFilr|\8E\DFilr|\92\DFilqz\96\DFhjmt\80\9D\DFhjmt\80\A5\DFhjms~\AD\DFhjms\7F\A2\C1\DFhjms\80\98\CF\DFhjms\80\97\DFhjmr\7F\95\DFikov\87\A3\DFhjmr~\94\DFhjmqz\8F\B0\DFhjmqz\92\B8\DFhjmqz\90\C1\DFhjmr|\96\D5\DFhjmr|\95\BA\DFhjmr|\97\BE\DFhjmr{\93\C3\DFhjmqw\85\AC\DFhjmqw\84\AC\DFhjmqw\85\B5\DFhjmqx\88\C0\DFhjmqy\8A\BD\DFhjmrz\8C\C1\DFhjmr{\8E\C6\DFhjmr|\8E\C4\DFhjmrx\81\9C\DFhjmqv\81\98\C1\DFhjmqv\83\9B\C3\DFhjlpw\85\9F\CB\DFhjmqx\88\A5\DA\DFhjmqy\8C\AD\DFhjlpv}\90\B6\DFhjmqw~\95\C3\DFhjmqw\7F\9B\D5\DFhjmqw\80\A1\DFhjlot~\87\AC\DFhjlot|\86\B6\D6\DFhjmqw\83\8D\CB\DFhjmpu}\8B\BA\DFhjlpv~\8F\C6\DFiknrx\81\94\D8\DFiknry\82\9A\DFiknry\83\9B\AC\DFiknrz\85\9E\B0\DFiknry\84\9D\B9\D4\DFhjmqv\7F\8B\A8\CB\DFhjmpu~\8D\AD\DFhjlpu~\8A\9A\C0\DFiknrw\81\90\A5\D3\DFiknrx\82\8E\9F\D6\DFiknrx\82\8F\A5\DFiknry\84\93\AE\DFiknsz\85\96\BB\DFjmqv~\8C\9E\CD\DFjmpu}\86\97\AB\DFjmqv~\86\96\AF\DFjmqw\80\89\9A\BB\DFjmqw\80\8A\9E\CD\DFknry\83\8D\A6\DFknry\84\91\AF\DFkns{\87\95\BB\DFknrx\80\8C\9C\CE\DFknrx\81\8E\A2\DFjmpu}\85\93\AC\D4\DFjmqw\80\89\99\B8\D1\DFjmqw\80\8A\9D\CA\DFjmry\83\8D\A5\DFjnsz\85\91\AE\DFjnsz\85\95\BB\DFjot|\8A\9B\CD\DFjou}\86\96\A5\DFjpv~\86\95\AC\D1\DFjpw\80\89\99\B8\D1\DFjqx\81\8A\9E\CA\DFjqy\83\8D\A5\DFjrz\85\91\AE\DFjrz\85\95\BB\DFjqv~\8B\9B\CD\DFilt}\86\96\A5\DFimv\82\92\AB\C3\DFimv\81\8A\9B\B8\CF\DFimw\82\8B\9E\CA\DFimy\87\92\A7\DFimz\88\93\AF\DFin{\8A\96\BC\DFin}\8D\9C\CE\DFjo\7F\91\A3\DFjo\81\95\AC\D4\DFjp\83\99\B9\D3\DFjp\86\A0\CA\DFjp\88\95\B1\DFjp\89\95\B4\DFjpx\8F\9C\C1\DFjnt\84\9A\D1\DFils\89\A2\DFjmt\8A\A5\B9\DFjmu\8C\A2\BA\D9\DFjnv\87\9F\CA\DFjnw\89\A7\DFimw\88\9C\BA\DFimw\86\9A\BF\DFiny\8A\A0\D1\DFinz\8C\A7\DFjo|\91\B1\DFjo}\91\BD\DFjoy\85\AB\D3\DFjov\83\9C\DFjou\85\9F\DFjou\87\A2\DFjou\8A\A7\DFjnt\8D\AE\DFjnu\91\B7\DFjnu\8E\A6\D7\DFimu\81\9E\D7\DFimv\83\A5\DFimv\81\AF\DFimv\80\BB\DFimt\7F\CD\DFimr|\8E\DFimr}\8C\DFimr~\8C\DFimr\80\8F\DFjns\82\92\DFjot\84\95\DFjou\86\99\DFjou\88\9F\DFjov\8B\A6\DFjow\8E\B0\DFilry\93\BD\DFilrz\97\CF\DFilrz\9A\D1\DFimt}\A0\CE\DFimt~\A4\D5\DFimu\80\AA\DFimv\81\B2\DFimv\83\BC\DFimt\82\A3\DFimrz\89\DFimq{\8D\DFimr|\91\DFimr~\96\DFimr\7F\9C\DFimr\81\A3\DFilr\83\AD\DFilr\81\9A\BB\DFilr{\8B\CC\DFilry\8D\DFilry\91\DFilry\95\DFilry\9B\DFilrz\A1\DFilr|\AB\DFilpy\85\BA\DFilq|\95\CE\DFilqz\84\DFilqz\85\DFilqz\87\DFilq{\89\DFilq{\8C\D9\DFilr}\91\DFilq|\95\DFilqy\87\9D\DFilqx\85\A3\DFilqx\86\AD\DFilpx\88\B9\DFhkow\8A\CB\DFhjmrz\8E\DFilq{\92\DFilq{\97\DFhjmr}\9D\DFhjms\7F\A5\DFhjmr}\8A\B0\DFhjmr|\89\BC\DFhjnt\82\91\CF\DFhjnt\80\8F\DFhjnt\7F\91\DFhjns|\94\DFhjmqy\8D\A1\DFhjmqz\8F\A7\DFhilqz\8C\AE\DFhikot~\98\BC\DFhjmr{\8D\C0\DFhikns}\91\C4\DFhiknt\7F\96\D0\DFhiknt}\8B\B4\DFhjmry\89\AB\DFhjmqx\87\A5\DFhjlpw\82\94\BF\DFhjlpx\83\98\CA\DFhjlpx\82\9C\DB\DFhjlpx\83\A3\DFhikns|\88\AD\DFhikns}\89\AE\D2\DFhikns~\8C\B2\D8\DFhikmqx\83\92\BD\DFhikmqw\83\93\C0\DFhikns{\88\99\CD\DFhiknsz\89\9E\DE\DFhiknry\8C\A5\DFhiknry\8A\9D\B7\DFhijlot}\95\BC\DFijlosz\86\9D\CE\DFiknry\84\A3\DFiknry\85\AC\DFiknqv\7F\8C\BA\DFikmqv\80\8D\BD\DFikmqv\80\8F\BF\DFhjlosx\83\93\C8\DFhjlosx\82\96\D0\DFhjlnrw\81\8F\A3\DFhjlnrw\7F\8E\A6\DFhjlot{\86\96\B0\DFhjlnrw}\89\9A\BD\DFhjlnrx\7F\8C\9F\CE\DFhilosy\81\8F\A6\DFhilosz\83\93\B0\DFhilorx~\86\98\BC\DFhilnqu~\88\9E\CE\DFhikmpt|\83\8D\A6\DFhiknrw\81\90\AF\DFhijnqty\84\94\BC\DFhijnqty\83\8C\9B\CE\DFhijlosw~\8C\A2\DFhijlosv|\88\92\AB\C1\DFhijlptw}\89\95\B8\CE\DFhijlptx\7F\8C\9B\C9\DFhijlquy\81\8F\A2\DFhijkmrw{\83\93\AB\C2\DFhikmrw|\85\98\B8\CF\DFhijkmsx~\88\9E\CA\DFhijlntz\80\8C\A5\DFhijlnu{\82\90\AF\DFhijlnuy\7F\85\94\BC\DFhijlnsx\7F\87\9A\CE\DFhijlmow{\82\8B\A2\D2\DFhijlnqz\83\8F\AB\C0\DFhijkmnq{\85\93\9F\B8\CE\DFhijlnq|\81\89\99\A4\CA\DFhijlnps~\84\8C\A0\AC\DFhijkmor|\82\8F\AA\B7\DFhijkmps\80\86\94\B6\C6\DFhijkmpsz\87\9A\C7\DA\DFhijlnqu\84\8B\A1\B3\DFhijlnqsv\86\8F\AA\BB\DFhijlnqsw\88\93\9F\B7\CB\DFhijlnqsx\8A\99\A4\C9\DFhijlmoruy\89\A0\AC\DFhijlnpsvz\88\A9\B6\DFhijlnptw|\8E\B6\C6\DFhjlnqtx~\93\C7\DA\DFhijlnpruy\7F\8E\C2\DFhikmorvz\81\89\B5\DFhikmoqtx|\84\9A\DB\DFhikmpruy}\87\9C\DFhikmoquy\7F\89\8F\B0\DFiklnqsv{\81\87\8F\A2\D3\DFikmortw|\84\92\99\C5\DFikmortx~\87\91\9A\A4\DA\DFikmorty\80\8A\91\A0\AA\DFikmoruz\82\8E\94\A9\B4\DFikmorv|\85\92\99\B5\C2\DFhjlnqtw{\7F\87\98\A0\C7\D7\DFhjloruy\7F\8B\9F\A8\DFikmorvz\81\88\90\A9\B3\DFiknpsw|\84\93\9F\B5\C0\DFikmpsx}\84\89\99\A5\C6\D4\DFikmpruy\7F\86\8B\A0\AC\DFilorvz\81\86\8E\95\AA\B8\DFikmpsw|\84\8C\93\9B\B6\C6\DFikmpsx~\86\8A\99\A1\C7\DA\DFikmpty\7F\8A\8F\A0\A9\DFikmpsvz\81\89\8E\93\A9\B4\DFiknqtw|\84\92\98\B5\C2\DFjmptx~\87\98\9E\C6\D5\DFjloruy\7F\8A\93\9F\A6\DFjlosvz\81\89\8F\A3\AB\B4\DFjlorw|\84\93\9B\B4\BE\C9\DFjlorvz~\87\98\A0\C6\D2\DFjlorvz\7F\87\8D\A0\A9\DFkmpsw{\81\86\8E\95\A9\B4\DFkmqtx|\84\8E\95\B5\C2\DFkmqtx~\86\8B\99\A1\C7\D7\DFkmquz\80\8A\90\A0\A9\DFlosv{\82\8E\94\A9\B4\DFlnrw}\84\92\98\B5\C1\DFlotx~\87\98\9F\C6\D5\DFloty\80\8A\94\A0\A8\DFmpuz\82\8E\96\A8\B1\DFmpu|\85\93\9C\B5\C0\DFmqw}\88\99\A2\C6\D3\DFnqv{\80\8B\A0\AA\DFnrw}\82\8F\A9\B4\DFosy\7F\84\94\B5\C2\DFosy\7F\87\99\A8\C7\D7\DFotz\81\8A\92\A1\B1\DFpu|\84\8E\95\AA\BA\DFqv}\86\93\9B\B7\C9\DFqw\7F\89\98\A0\C8\DFry\81\8C\A0\A9\DFry\7F\89\93\A9\B4\DFs{\86\94\B5\C1\DFt}\89\9A\C6\D5\DFu~\84\8E\A2\CF\DFv\80\86\91\AB\BF\DFw\81\87\95\B7\CC\DFx\83\89\9B\C9\DFy\84\8B\A2\DF{\87\8F\AB\C4\DF|\89\93\9E\B9\D2\DF~\8C\99\A4\CA\DF\80\8F\A0\AC\DF\82\93\AA\B8\DF\85\98\B6\C6\DF\87\9E\C7\DA\DF\8B\A5\DF\8F\AF\DF\94\BC\DF\9A\CE\DF\A1\B9\DF\AB\C2\DF\B7\CE\DF\C9\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF\DF", align 1
@_ZN5rallyL13TriOvalPointsE = internal constant [90 x %"struct.rally::TrackPoint"] [%"struct.rally::TrackPoint" { i16 0, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 64, i16 -1, i16 4094, i16 -125 }, %"struct.rally::TrackPoint" { i16 128, i16 -4, i16 4088, i16 -255 }, %"struct.rally::TrackPoint" { i16 192, i16 -9, i16 4078, i16 -382 }, %"struct.rally::TrackPoint" { i16 255, i16 -16, i16 4066, i16 -494 }, %"struct.rally::TrackPoint" { i16 319, i16 -24, i16 4054, i16 -588 }, %"struct.rally::TrackPoint" { i16 382, i16 -34, i16 4042, i16 -662 }, %"struct.rally::TrackPoint" { i16 445, i16 -45, i16 4033, i16 -717 }, %"struct.rally::TrackPoint" { i16 508, i16 -56, i16 4024, i16 -765 }, %"struct.rally::TrackPoint" { i16 571, i16 -69, i16 4005, i16 -857 }, %"struct.rally::TrackPoint" { i16 633, i16 -83, i16 3980, i16 -969 }, %"struct.rally::TrackPoint" { i16 695, i16 -99, i16 3944, i16 -1107 }, %"struct.rally::TrackPoint" { i16 756, i16 -118, i16 3893, i16 -1275 }, %"struct.rally::TrackPoint" { i16 817, i16 -139, i16 3819, i16 -1480 }, %"struct.rally::TrackPoint" { i16 876, i16 -165, i16 3713, i16 -1730 }, %"struct.rally::TrackPoint" { i16 932, i16 -194, i16 3558, i16 -2030 }, %"struct.rally::TrackPoint" { i16 986, i16 -228, i16 3332, i16 -2382 }, %"struct.rally::TrackPoint" { i16 1036, i16 -268, i16 3011, i16 -2777 }, %"struct.rally::TrackPoint" { i16 1080, i16 -315, i16 2576, i16 -3185 }, %"struct.rally::TrackPoint" { i16 1116, i16 -368, i16 2036, i16 -3554 }, %"struct.rally::TrackPoint" { i16 1143, i16 -426, i16 1437, i16 -3836 }, %"struct.rally::TrackPoint" { i16 1161, i16 -487, i16 848, i16 -4007 }, %"struct.rally::TrackPoint" { i16 1170, i16 -550, i16 319, i16 -4084 }, %"struct.rally::TrackPoint" { i16 1171, i16 -614, i16 -135, i16 -4094 }, %"struct.rally::TrackPoint" { i16 1165, i16 -678, i16 -634, i16 -4047 }, %"struct.rally::TrackPoint" { i16 1151, i16 -740, i16 -1213, i16 -3912 }, %"struct.rally::TrackPoint" { i16 1127, i16 -800, i16 -1837, i16 -3661 }, %"struct.rally::TrackPoint" { i16 1094, i16 -854, i16 -2441, i16 -3289 }, %"struct.rally::TrackPoint" { i16 1051, i16 -902, i16 -2960, i16 -2831 }, %"struct.rally::TrackPoint" { i16 1002, i16 -943, i16 -3354, i16 -2351 }, %"struct.rally::TrackPoint" { i16 947, i16 -976, i16 -3631, i16 -1896 }, %"struct.rally::TrackPoint" { i16 889, i16 -1002, i16 -3814, i16 -1493 }, %"struct.rally::TrackPoint" { i16 828, i16 -1023, i16 -3932, i16 -1146 }, %"struct.rally::TrackPoint" { i16 766, i16 -1038, i16 -4007, i16 -851 }, %"struct.rally::TrackPoint" { i16 703, i16 -1049, i16 -4052, i16 -600 }, %"struct.rally::TrackPoint" { i16 640, i16 -1057, i16 -4078, i16 -386 }, %"struct.rally::TrackPoint" { i16 576, i16 -1062, i16 -4091, i16 -200 }, %"struct.rally::TrackPoint" { i16 512, i16 -1063, i16 -4096, i16 -38 }, %"struct.rally::TrackPoint" { i16 448, i16 -1063, i16 -4096, i16 0 }, %"struct.rally::TrackPoint" { i16 384, i16 -1063, i16 -4096, i16 0 }, %"struct.rally::TrackPoint" { i16 320, i16 -1063, i16 -4096, i16 0 }, %"struct.rally::TrackPoint" { i16 256, i16 -1063, i16 -4096, i16 0 }, %"struct.rally::TrackPoint" { i16 192, i16 -1063, i16 -4096, i16 0 }, %"struct.rally::TrackPoint" { i16 128, i16 -1063, i16 -4096, i16 0 }, %"struct.rally::TrackPoint" { i16 64, i16 -1063, i16 -4096, i16 0 }, %"struct.rally::TrackPoint" { i16 0, i16 -1063, i16 -4096, i16 0 }, %"struct.rally::TrackPoint" { i16 -64, i16 -1063, i16 -4096, i16 0 }, %"struct.rally::TrackPoint" { i16 -128, i16 -1063, i16 -4096, i16 0 }, %"struct.rally::TrackPoint" { i16 -192, i16 -1063, i16 -4096, i16 0 }, %"struct.rally::TrackPoint" { i16 -256, i16 -1063, i16 -4096, i16 0 }, %"struct.rally::TrackPoint" { i16 -320, i16 -1063, i16 -4096, i16 0 }, %"struct.rally::TrackPoint" { i16 -384, i16 -1063, i16 -4096, i16 0 }, %"struct.rally::TrackPoint" { i16 -448, i16 -1063, i16 -4096, i16 0 }, %"struct.rally::TrackPoint" { i16 -512, i16 -1063, i16 -4096, i16 38 }, %"struct.rally::TrackPoint" { i16 -576, i16 -1062, i16 -4091, i16 200 }, %"struct.rally::TrackPoint" { i16 -640, i16 -1057, i16 -4078, i16 386 }, %"struct.rally::TrackPoint" { i16 -703, i16 -1049, i16 -4052, i16 600 }, %"struct.rally::TrackPoint" { i16 -766, i16 -1038, i16 -4007, i16 851 }, %"struct.rally::TrackPoint" { i16 -828, i16 -1023, i16 -3932, i16 1146 }, %"struct.rally::TrackPoint" { i16 -889, i16 -1002, i16 -3814, i16 1493 }, %"struct.rally::TrackPoint" { i16 -947, i16 -976, i16 -3631, i16 1896 }, %"struct.rally::TrackPoint" { i16 -1002, i16 -943, i16 -3354, i16 2351 }, %"struct.rally::TrackPoint" { i16 -1051, i16 -902, i16 -2960, i16 2831 }, %"struct.rally::TrackPoint" { i16 -1094, i16 -854, i16 -2441, i16 3289 }, %"struct.rally::TrackPoint" { i16 -1127, i16 -800, i16 -1837, i16 3661 }, %"struct.rally::TrackPoint" { i16 -1151, i16 -740, i16 -1213, i16 3912 }, %"struct.rally::TrackPoint" { i16 -1165, i16 -678, i16 -634, i16 4047 }, %"struct.rally::TrackPoint" { i16 -1171, i16 -614, i16 -135, i16 4094 }, %"struct.rally::TrackPoint" { i16 -1170, i16 -550, i16 319, i16 4084 }, %"struct.rally::TrackPoint" { i16 -1161, i16 -487, i16 848, i16 4007 }, %"struct.rally::TrackPoint" { i16 -1143, i16 -426, i16 1437, i16 3836 }, %"struct.rally::TrackPoint" { i16 -1116, i16 -368, i16 2036, i16 3554 }, %"struct.rally::TrackPoint" { i16 -1080, i16 -315, i16 2576, i16 3185 }, %"struct.rally::TrackPoint" { i16 -1036, i16 -268, i16 3011, i16 2777 }, %"struct.rally::TrackPoint" { i16 -986, i16 -228, i16 3332, i16 2382 }, %"struct.rally::TrackPoint" { i16 -932, i16 -194, i16 3558, i16 2030 }, %"struct.rally::TrackPoint" { i16 -876, i16 -165, i16 3713, i16 1730 }, %"struct.rally::TrackPoint" { i16 -817, i16 -139, i16 3819, i16 1480 }, %"struct.rally::TrackPoint" { i16 -756, i16 -118, i16 3893, i16 1275 }, %"struct.rally::TrackPoint" { i16 -695, i16 -99, i16 3944, i16 1107 }, %"struct.rally::TrackPoint" { i16 -633, i16 -83, i16 3980, i16 969 }, %"struct.rally::TrackPoint" { i16 -571, i16 -69, i16 4005, i16 857 }, %"struct.rally::TrackPoint" { i16 -508, i16 -56, i16 4024, i16 765 }, %"struct.rally::TrackPoint" { i16 -445, i16 -45, i16 4033, i16 717 }, %"struct.rally::TrackPoint" { i16 -382, i16 -34, i16 4042, i16 662 }, %"struct.rally::TrackPoint" { i16 -319, i16 -24, i16 4054, i16 588 }, %"struct.rally::TrackPoint" { i16 -255, i16 -16, i16 4066, i16 494 }, %"struct.rally::TrackPoint" { i16 -192, i16 -9, i16 4078, i16 382 }, %"struct.rally::TrackPoint" { i16 -128, i16 -4, i16 4088, i16 255 }, %"struct.rally::TrackPoint" { i16 -64, i16 -1, i16 4094, i16 125 }], align 1
@.str.13 = private unnamed_addr constant [9 x i8] c"Tri-oval\00", align 1
@_ZN5rallyL10FujiPointsE = internal constant [512 x %"struct.rally::TrackPoint"] [%"struct.rally::TrackPoint" { i16 0, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 64, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 128, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 192, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 256, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 320, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 384, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 448, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 512, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 576, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 640, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 704, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 768, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 832, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 896, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 960, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 1024, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 1088, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 1152, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 1216, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 1280, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 1344, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 1408, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 1472, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 1536, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 1600, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 1664, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 1728, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 1792, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 1856, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 1920, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 1984, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 2048, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 2112, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 2176, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 2240, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 2304, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 2368, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 2432, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 2496, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 2560, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 2624, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 2688, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 2752, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 2816, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 2880, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 2944, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 3008, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 3072, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 3136, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 3200, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 3264, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 3328, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 3392, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 3456, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 3520, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 3584, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 3648, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 3712, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 3776, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 3840, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 3904, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 3968, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 4032, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 4096, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 4160, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 4224, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 4288, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 4352, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 4416, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 4480, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 4544, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 4608, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 4672, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 4736, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 4800, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 4864, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 4928, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 4992, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 5056, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 5120, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 5184, i16 1, i16 4089, i16 246 }, %"struct.rally::TrackPoint" { i16 5248, i16 8, i16 4046, i16 638 }, %"struct.rally::TrackPoint" { i16 5310, i16 21, i16 3959, i16 1052 }, %"struct.rally::TrackPoint" { i16 5371, i16 41, i16 3820, i16 1479 }, %"struct.rally::TrackPoint" { i16 5429, i16 68, i16 3627, i16 1903 }, %"struct.rally::TrackPoint" { i16 5484, i16 100, i16 3381, i16 2312 }, %"struct.rally::TrackPoint" { i16 5535, i16 140, i16 3085, i16 2694 }, %"struct.rally::TrackPoint" { i16 5580, i16 184, i16 2747, i16 3038 }, %"struct.rally::TrackPoint" { i16 5620, i16 234, i16 2375, i16 3337 }, %"struct.rally::TrackPoint" { i16 5654, i16 289, i16 1974, i16 3589 }, %"struct.rally::TrackPoint" { i16 5682, i16 346, i16 1551, i16 3791 }, %"struct.rally::TrackPoint" { i16 5703, i16 407, i16 1109, i16 3943 }, %"struct.rally::TrackPoint" { i16 5716, i16 469, i16 652, i16 4044 }, %"struct.rally::TrackPoint" { i16 5723, i16 533, i16 179, i16 4092 }, %"struct.rally::TrackPoint" { i16 5722, i16 597, i16 -305, i16 4085 }, %"struct.rally::TrackPoint" { i16 5713, i16 660, i16 -795, i16 4018 }, %"struct.rally::TrackPoint" { i16 5697, i16 722, i16 -1285, i16 3889 }, %"struct.rally::TrackPoint" { i16 5673, i16 781, i16 -1764, i16 3697 }, %"struct.rally::TrackPoint" { i16 5642, i16 837, i16 -2218, i16 3444 }, %"struct.rally::TrackPoint" { i16 5604, i16 889, i16 -2632, i16 3138 }, %"struct.rally::TrackPoint" { i16 5560, i16 935, i16 -2995, i16 2794 }, %"struct.rally::TrackPoint" { i16 5511, i16 976, i16 -3299, i16 2428 }, %"struct.rally::TrackPoint" { i16 5457, i16 1011, i16 -3543, i16 2056 }, %"struct.rally::TrackPoint" { i16 5401, i16 1040, i16 -3730, i16 1692 }, %"struct.rally::TrackPoint" { i16 5341, i16 1064, i16 -3868, i16 1347 }, %"struct.rally::TrackPoint" { i16 5280, i16 1082, i16 -3966, i16 1026 }, %"struct.rally::TrackPoint" { i16 5217, i16 1097, i16 -4010, i16 837 }, %"struct.rally::TrackPoint" { i16 5155, i16 1108, i16 -4040, i16 676 }, %"struct.rally::TrackPoint" { i16 5091, i16 1118, i16 -4059, i16 549 }, %"struct.rally::TrackPoint" { i16 5028, i16 1126, i16 -4072, i16 447 }, %"struct.rally::TrackPoint" { i16 4964, i16 1132, i16 -4080, i16 366 }, %"struct.rally::TrackPoint" { i16 4900, i16 1137, i16 -4085, i16 302 }, %"struct.rally::TrackPoint" { i16 4836, i16 1142, i16 -4088, i16 251 }, %"struct.rally::TrackPoint" { i16 4773, i16 1145, i16 -4091, i16 212 }, %"struct.rally::TrackPoint" { i16 4709, i16 1148, i16 -4092, i16 182 }, %"struct.rally::TrackPoint" { i16 4645, i16 1151, i16 -4093, i16 161 }, %"struct.rally::TrackPoint" { i16 4581, i16 1153, i16 -4093, i16 147 }, %"struct.rally::TrackPoint" { i16 4517, i16 1155, i16 -4094, i16 141 }, %"struct.rally::TrackPoint" { i16 4453, i16 1158, i16 -4094, i16 141 }, %"struct.rally::TrackPoint" { i16 4389, i16 1160, i16 -4093, i16 147 }, %"struct.rally::TrackPoint" { i16 4325, i16 1162, i16 -4093, i16 158 }, %"struct.rally::TrackPoint" { i16 4261, i16 1165, i16 -4092, i16 176 }, %"struct.rally::TrackPoint" { i16 4197, i16 1168, i16 -4091, i16 198 }, %"struct.rally::TrackPoint" { i16 4133, i16 1171, i16 -4090, i16 227 }, %"struct.rally::TrackPoint" { i16 4069, i16 1175, i16 -4088, i16 261 }, %"struct.rally::TrackPoint" { i16 4005, i16 1179, i16 -4085, i16 302 }, %"struct.rally::TrackPoint" { i16 3942, i16 1184, i16 -4081, i16 348 }, %"struct.rally::TrackPoint" { i16 3878, i16 1190, i16 -4076, i16 401 }, %"struct.rally::TrackPoint" { i16 3814, i16 1197, i16 -4070, i16 461 }, %"struct.rally::TrackPoint" { i16 3751, i16 1205, i16 -4062, i16 529 }, %"struct.rally::TrackPoint" { i16 3687, i16 1214, i16 -4051, i16 605 }, %"struct.rally::TrackPoint" { i16 3624, i16 1224, i16 -4038, i16 689 }, %"struct.rally::TrackPoint" { i16 3561, i16 1235, i16 -4020, i16 784 }, %"struct.rally::TrackPoint" { i16 3498, i16 1248, i16 -3998, i16 889 }, %"struct.rally::TrackPoint" { i16 3436, i16 1263, i16 -3971, i16 1006 }, %"struct.rally::TrackPoint" { i16 3374, i16 1280, i16 -3935, i16 1136 }, %"struct.rally::TrackPoint" { i16 3313, i16 1299, i16 -3891, i16 1279 }, %"struct.rally::TrackPoint" { i16 3253, i16 1320, i16 -3836, i16 1437 }, %"struct.rally::TrackPoint" { i16 3193, i16 1343, i16 -3766, i16 1611 }, %"struct.rally::TrackPoint" { i16 3135, i16 1370, i16 -3680, i16 1800 }, %"struct.rally::TrackPoint" { i16 3079, i16 1400, i16 -3573, i16 2003 }, %"struct.rally::TrackPoint" { i16 3024, i16 1433, i16 -3442, i16 2220 }, %"struct.rally::TrackPoint" { i16 2971, i16 1469, i16 -3283, i16 2449 }, %"struct.rally::TrackPoint" { i16 2921, i16 1509, i16 -3096, i16 2681 }, %"struct.rally::TrackPoint" { i16 2875, i16 1553, i16 -2879, i16 2914 }, %"struct.rally::TrackPoint" { i16 2831, i16 1600, i16 -2633, i16 3138 }, %"struct.rally::TrackPoint" { i16 2792, i16 1651, i16 -2365, i16 3345 }, %"struct.rally::TrackPoint" { i16 2758, i16 1705, i16 -2081, i16 3528 }, %"struct.rally::TrackPoint" { i16 2726, i16 1760, i16 -1993, i16 3578 }, %"struct.rally::TrackPoint" { i16 2695, i16 1817, i16 -1884, i16 3637 }, %"struct.rally::TrackPoint" { i16 2667, i16 1874, i16 -1798, i16 3680 }, %"struct.rally::TrackPoint" { i16 2639, i16 1931, i16 -1729, i16 3713 }, %"struct.rally::TrackPoint" { i16 2613, i16 1990, i16 -1674, i16 3739 }, %"struct.rally::TrackPoint" { i16 2587, i16 2048, i16 -1628, i16 3759 }, %"struct.rally::TrackPoint" { i16 2562, i16 2107, i16 -1591, i16 3774 }, %"struct.rally::TrackPoint" { i16 2537, i16 2166, i16 -1561, i16 3787 }, %"struct.rally::TrackPoint" { i16 2513, i16 2225, i16 -1537, i16 3797 }, %"struct.rally::TrackPoint" { i16 2489, i16 2285, i16 -1518, i16 3804 }, %"struct.rally::TrackPoint" { i16 2465, i16 2344, i16 -1503, i16 3810 }, %"struct.rally::TrackPoint" { i16 2442, i16 2404, i16 -1492, i16 3815 }, %"struct.rally::TrackPoint" { i16 2419, i16 2464, i16 -1485, i16 3817 }, %"struct.rally::TrackPoint" { i16 2396, i16 2523, i16 -1481, i16 3819 }, %"struct.rally::TrackPoint" { i16 2372, i16 2583, i16 -1480, i16 3819 }, %"struct.rally::TrackPoint" { i16 2349, i16 2643, i16 -1482, i16 3818 }, %"struct.rally::TrackPoint" { i16 2326, i16 2702, i16 -1487, i16 3817 }, %"struct.rally::TrackPoint" { i16 2303, i16 2762, i16 -1494, i16 3814 }, %"struct.rally::TrackPoint" { i16 2279, i16 2821, i16 -1504, i16 3810 }, %"struct.rally::TrackPoint" { i16 2256, i16 2881, i16 -1517, i16 3805 }, %"struct.rally::TrackPoint" { i16 2232, i16 2940, i16 -1533, i16 3798 }, %"struct.rally::TrackPoint" { i16 2208, i16 3000, i16 -1551, i16 3791 }, %"struct.rally::TrackPoint" { i16 2183, i16 3059, i16 -1572, i16 3782 }, %"struct.rally::TrackPoint" { i16 2159, i16 3118, i16 -1596, i16 3772 }, %"struct.rally::TrackPoint" { i16 2134, i16 3177, i16 -1624, i16 3760 }, %"struct.rally::TrackPoint" { i16 2108, i16 3235, i16 -1654, i16 3747 }, %"struct.rally::TrackPoint" { i16 2082, i16 3294, i16 -1689, i16 3732 }, %"struct.rally::TrackPoint" { i16 2055, i16 3352, i16 -1727, i16 3714 }, %"struct.rally::TrackPoint" { i16 2028, i16 3410, i16 -1770, i16 3694 }, %"struct.rally::TrackPoint" { i16 2000, i16 3467, i16 -1818, i16 3670 }, %"struct.rally::TrackPoint" { i16 1971, i16 3524, i16 -1871, i16 3644 }, %"struct.rally::TrackPoint" { i16 1941, i16 3581, i16 -1931, i16 3612 }, %"struct.rally::TrackPoint" { i16 1911, i16 3637, i16 -1997, i16 3576 }, %"struct.rally::TrackPoint" { i16 1879, i16 3693, i16 -2071, i16 3534 }, %"struct.rally::TrackPoint" { i16 1846, i16 3748, i16 -2154, i16 3484 }, %"struct.rally::TrackPoint" { i16 1811, i16 3802, i16 -2248, i16 3424 }, %"struct.rally::TrackPoint" { i16 1776, i16 3855, i16 -2353, i16 3352 }, %"struct.rally::TrackPoint" { i16 1738, i16 3906, i16 -2473, i16 3265 }, %"struct.rally::TrackPoint" { i16 1698, i16 3957, i16 -2608, i16 3158 }, %"struct.rally::TrackPoint" { i16 1656, i16 4005, i16 -2921, i16 2872 }, %"struct.rally::TrackPoint" { i16 1608, i16 4047, i16 -3225, i16 2525 }, %"struct.rally::TrackPoint" { i16 1555, i16 4083, i16 -3477, i16 2165 }, %"struct.rally::TrackPoint" { i16 1499, i16 4114, i16 -3686, i16 1786 }, %"struct.rally::TrackPoint" { i16 1440, i16 4139, i16 -3851, i16 1395 }, %"struct.rally::TrackPoint" { i16 1379, i16 4158, i16 -3972, i16 1000 }, %"struct.rally::TrackPoint" { i16 1316, i16 4170, i16 -4051, i16 605 }, %"struct.rally::TrackPoint" { i16 1253, i16 4177, i16 -4090, i16 214 }, %"struct.rally::TrackPoint" { i16 1189, i16 4177, i16 -4092, i16 -172 }, %"struct.rally::TrackPoint" { i16 1125, i16 4171, i16 -4058, i16 -554 }, %"struct.rally::TrackPoint" { i16 1062, i16 4160, i16 -3989, i16 -930 }, %"struct.rally::TrackPoint" { i16 1001, i16 4142, i16 -3884, i16 -1302 }, %"struct.rally::TrackPoint" { i16 941, i16 4119, i16 -3741, i16 -1667 }, %"struct.rally::TrackPoint" { i16 884, i16 4090, i16 -3560, i16 -2025 }, %"struct.rally::TrackPoint" { i16 830, i16 4056, i16 -3339, i16 -2373 }, %"struct.rally::TrackPoint" { i16 780, i16 4016, i16 -3077, i16 -2704 }, %"struct.rally::TrackPoint" { i16 734, i16 3972, i16 -2774, i16 -3013 }, %"struct.rally::TrackPoint" { i16 693, i16 3922, i16 -2436, i16 -3293 }, %"struct.rally::TrackPoint" { i16 658, i16 3869, i16 -2069, i16 -3535 }, %"struct.rally::TrackPoint" { i16 629, i16 3812, i16 -1683, i16 -3734 }, %"struct.rally::TrackPoint" { i16 606, i16 3752, i16 -1289, i16 -3888 }, %"struct.rally::TrackPoint" { i16 588, i16 3691, i16 -900, i16 -3996 }, %"struct.rally::TrackPoint" { i16 577, i16 3628, i16 -524, i16 -4062 }, %"struct.rally::TrackPoint" { i16 572, i16 3564, i16 -170, i16 -4092 }, %"struct.rally::TrackPoint" { i16 569, i16 3500, i16 -271, i16 -4087 }, %"struct.rally::TrackPoint" { i16 566, i16 3436, i16 -100, i16 -4095 }, %"struct.rally::TrackPoint" { i16 566, i16 3372, i16 37, i16 -4096 }, %"struct.rally::TrackPoint" { i16 567, i16 3308, i16 150, i16 -4093 }, %"struct.rally::TrackPoint" { i16 570, i16 3244, i16 244, i16 -4089 }, %"struct.rally::TrackPoint" { i16 575, i16 3180, i16 323, i16 -4083 }, %"struct.rally::TrackPoint" { i16 580, i16 3117, i16 390, i16 -4077 }, %"struct.rally::TrackPoint" { i16 587, i16 3053, i16 448, i16 -4071 }, %"struct.rally::TrackPoint" { i16 594, i16 2989, i16 498, i16 -4066 }, %"struct.rally::TrackPoint" { i16 602, i16 2926, i16 541, i16 -4060 }, %"struct.rally::TrackPoint" { i16 611, i16 2863, i16 579, i16 -4055 }, %"struct.rally::TrackPoint" { i16 620, i16 2799, i16 612, i16 -4050 }, %"struct.rally::TrackPoint" { i16 630, i16 2736, i16 640, i16 -4046 }, %"struct.rally::TrackPoint" { i16 640, i16 2673, i16 665, i16 -4042 }, %"struct.rally::TrackPoint" { i16 651, i16 2610, i16 686, i16 -4038 }, %"struct.rally::TrackPoint" { i16 662, i16 2547, i16 703, i16 -4035 }, %"struct.rally::TrackPoint" { i16 673, i16 2484, i16 718, i16 -4033 }, %"struct.rally::TrackPoint" { i16 684, i16 2421, i16 729, i16 -4031 }, %"struct.rally::TrackPoint" { i16 696, i16 2358, i16 737, i16 -4029 }, %"struct.rally::TrackPoint" { i16 707, i16 2295, i16 743, i16 -4028 }, %"struct.rally::TrackPoint" { i16 719, i16 2232, i16 745, i16 -4028 }, %"struct.rally::TrackPoint" { i16 730, i16 2169, i16 743, i16 -4028 }, %"struct.rally::TrackPoint" { i16 742, i16 2106, i16 738, i16 -4029 }, %"struct.rally::TrackPoint" { i16 753, i16 2043, i16 729, i16 -4031 }, %"struct.rally::TrackPoint" { i16 765, i16 1980, i16 714, i16 -4033 }, %"struct.rally::TrackPoint" { i16 776, i16 1917, i16 694, i16 -4037 }, %"struct.rally::TrackPoint" { i16 786, i16 1854, i16 667, i16 -4041 }, %"struct.rally::TrackPoint" { i16 797, i16 1791, i16 631, i16 -4047 }, %"struct.rally::TrackPoint" { i16 806, i16 1727, i16 582, i16 -4054 }, %"struct.rally::TrackPoint" { i16 815, i16 1664, i16 516, i16 -4063 }, %"struct.rally::TrackPoint" { i16 822, i16 1600, i16 424, i16 -4074 }, %"struct.rally::TrackPoint" { i16 828, i16 1536, i16 291, i16 -4086 }, %"struct.rally::TrackPoint" { i16 831, i16 1473, i16 83, i16 -4095 }, %"struct.rally::TrackPoint" { i16 829, i16 1409, i16 -438, i16 -4073 }, %"struct.rally::TrackPoint" { i16 816, i16 1346, i16 -1236, i16 -3905 }, %"struct.rally::TrackPoint" { i16 789, i16 1288, i16 -2241, i16 -3429 }, %"struct.rally::TrackPoint" { i16 746, i16 1241, i16 -3243, i16 -2501 }, %"struct.rally::TrackPoint" { i16 689, i16 1212, i16 -3889, i16 -1286 }, %"struct.rally::TrackPoint" { i16 627, i16 1201, i16 -4094, i16 -142 }, %"struct.rally::TrackPoint" { i16 563, i16 1206, i16 -4021, i16 780 }, %"struct.rally::TrackPoint" { i16 502, i16 1224, i16 -3810, i16 1505 }, %"struct.rally::TrackPoint" { i16 444, i16 1252, i16 -3524, i16 2087 }, %"struct.rally::TrackPoint" { i16 392, i16 1289, i16 -3190, i16 2569 }, %"struct.rally::TrackPoint" { i16 345, i16 1332, i16 -2818, i16 2973 }, %"struct.rally::TrackPoint" { i16 304, i16 1381, i16 -2412, i16 3310 }, %"struct.rally::TrackPoint" { i16 270, i16 1435, i16 -1980, i16 3586 }, %"struct.rally::TrackPoint" { i16 237, i16 1490, i16 -2154, i16 3484 }, %"struct.rally::TrackPoint" { i16 204, i16 1545, i16 -2102, i16 3516 }, %"struct.rally::TrackPoint" { i16 171, i16 1600, i16 -2065, i16 3538 }, %"struct.rally::TrackPoint" { i16 139, i16 1656, i16 -2037, i16 3553 }, %"struct.rally::TrackPoint" { i16 107, i16 1711, i16 -2017, i16 3565 }, %"struct.rally::TrackPoint" { i16 76, i16 1767, i16 -2003, i16 3573 }, %"struct.rally::TrackPoint" { i16 45, i16 1823, i16 -1993, i16 3579 }, %"struct.rally::TrackPoint" { i16 14, i16 1879, i16 -1987, i16 3582 }, %"struct.rally::TrackPoint" { i16 -17, i16 1935, i16 -1983, i16 3584 }, %"struct.rally::TrackPoint" { i16 -48, i16 1991, i16 -1983, i16 3584 }, %"struct.rally::TrackPoint" { i16 -79, i16 2047, i16 -1985, i16 3583 }, %"struct.rally::TrackPoint" { i16 -110, i16 2103, i16 -1989, i16 3581 }, %"struct.rally::TrackPoint" { i16 -141, i16 2159, i16 -1994, i16 3578 }, %"struct.rally::TrackPoint" { i16 -173, i16 2215, i16 -2002, i16 3574 }, %"struct.rally::TrackPoint" { i16 -204, i16 2270, i16 -2011, i16 3568 }, %"struct.rally::TrackPoint" { i16 -235, i16 2326, i16 -2022, i16 3562 }, %"struct.rally::TrackPoint" { i16 -267, i16 2382, i16 -2034, i16 3555 }, %"struct.rally::TrackPoint" { i16 -299, i16 2437, i16 -2047, i16 3548 }, %"struct.rally::TrackPoint" { i16 -331, i16 2492, i16 -2063, i16 3539 }, %"struct.rally::TrackPoint" { i16 -363, i16 2548, i16 -2079, i16 3529 }, %"struct.rally::TrackPoint" { i16 -396, i16 2603, i16 -2097, i16 3518 }, %"struct.rally::TrackPoint" { i16 -429, i16 2658, i16 -2117, i16 3507 }, %"struct.rally::TrackPoint" { i16 -462, i16 2712, i16 -2138, i16 3494 }, %"struct.rally::TrackPoint" { i16 -496, i16 2767, i16 -2161, i16 3480 }, %"struct.rally::TrackPoint" { i16 -530, i16 2821, i16 -2185, i16 3464 }, %"struct.rally::TrackPoint" { i16 -564, i16 2875, i16 -2211, i16 3448 }, %"struct.rally::TrackPoint" { i16 -599, i16 2929, i16 -2239, i16 3430 }, %"struct.rally::TrackPoint" { i16 -634, i16 2982, i16 -2269, i16 3410 }, %"struct.rally::TrackPoint" { i16 -670, i16 3035, i16 -2301, i16 3388 }, %"struct.rally::TrackPoint" { i16 -706, i16 3088, i16 -2336, i16 3365 }, %"struct.rally::TrackPoint" { i16 -743, i16 3140, i16 -2372, i16 3339 }, %"struct.rally::TrackPoint" { i16 -780, i16 3192, i16 -2412, i16 3310 }, %"struct.rally::TrackPoint" { i16 -818, i16 3244, i16 -2455, i16 3279 }, %"struct.rally::TrackPoint" { i16 -857, i16 3295, i16 -2500, i16 3245 }, %"struct.rally::TrackPoint" { i16 -896, i16 3345, i16 -2549, i16 3206 }, %"struct.rally::TrackPoint" { i16 -937, i16 3395, i16 -2602, i16 3164 }, %"struct.rally::TrackPoint" { i16 -978, i16 3444, i16 -2658, i16 3116 }, %"struct.rally::TrackPoint" { i16 -1020, i16 3492, i16 -2720, i16 3063 }, %"struct.rally::TrackPoint" { i16 -1063, i16 3540, i16 -2786, i16 3002 }, %"struct.rally::TrackPoint" { i16 -1107, i16 3586, i16 -2858, i16 2934 }, %"struct.rally::TrackPoint" { i16 -1152, i16 3631, i16 -2936, i16 2856 }, %"struct.rally::TrackPoint" { i16 -1199, i16 3675, i16 -3021, i16 2766 }, %"struct.rally::TrackPoint" { i16 -1246, i16 3718, i16 -3112, i16 2663 }, %"struct.rally::TrackPoint" { i16 -1296, i16 3759, i16 -3211, i16 2543 }, %"struct.rally::TrackPoint" { i16 -1347, i16 3797, i16 -3317, i16 2402 }, %"struct.rally::TrackPoint" { i16 -1400, i16 3833, i16 -3430, i16 2238 }, %"struct.rally::TrackPoint" { i16 -1454, i16 3867, i16 -3550, i16 2043 }, %"struct.rally::TrackPoint" { i16 -1510, i16 3898, i16 -3543, i16 2056 }, %"struct.rally::TrackPoint" { i16 -1566, i16 3930, i16 -3579, i16 1992 }, %"struct.rally::TrackPoint" { i16 -1622, i16 3960, i16 -3653, i16 1854 }, %"struct.rally::TrackPoint" { i16 -1680, i16 3988, i16 -3718, i16 1719 }, %"struct.rally::TrackPoint" { i16 -1738, i16 4014, i16 -3774, i16 1592 }, %"struct.rally::TrackPoint" { i16 -1798, i16 4037, i16 -3824, i16 1468 }, %"struct.rally::TrackPoint" { i16 -1858, i16 4059, i16 -3867, i16 1350 }, %"struct.rally::TrackPoint" { i16 -1918, i16 4080, i16 -3905, i16 1237 }, %"struct.rally::TrackPoint" { i16 -1980, i16 4098, i16 -3937, i16 1129 }, %"struct.rally::TrackPoint" { i16 -2041, i16 4115, i16 -3966, i16 1025 }, %"struct.rally::TrackPoint" { i16 -2104, i16 4130, i16 -3990, i16 925 }, %"struct.rally::TrackPoint" { i16 -2166, i16 4144, i16 -4011, i16 829 }, %"struct.rally::TrackPoint" { i16 -2229, i16 4156, i16 -4029, i16 737 }, %"struct.rally::TrackPoint" { i16 -2292, i16 4167, i16 -4044, i16 649 }, %"struct.rally::TrackPoint" { i16 -2355, i16 4176, i16 -4057, i16 563 }, %"struct.rally::TrackPoint" { i16 -2419, i16 4185, i16 -4068, i16 481 }, %"struct.rally::TrackPoint" { i16 -2482, i16 4191, i16 -4076, i16 401 }, %"struct.rally::TrackPoint" { i16 -2546, i16 4197, i16 -4083, i16 323 }, %"struct.rally::TrackPoint" { i16 -2610, i16 4202, i16 -4088, i16 248 }, %"struct.rally::TrackPoint" { i16 -2674, i16 4205, i16 -4092, i16 174 }, %"struct.rally::TrackPoint" { i16 -2738, i16 4207, i16 -4095, i16 102 }, %"struct.rally::TrackPoint" { i16 -2802, i16 4208, i16 -4096, i16 31 }, %"struct.rally::TrackPoint" { i16 -2866, i16 4208, i16 -4096, i16 -38 }, %"struct.rally::TrackPoint" { i16 -2930, i16 4207, i16 -4095, i16 -106 }, %"struct.rally::TrackPoint" { i16 -2994, i16 4205, i16 -4092, i16 -174 }, %"struct.rally::TrackPoint" { i16 -3058, i16 4201, i16 -4089, i16 -242 }, %"struct.rally::TrackPoint" { i16 -3122, i16 4197, i16 -4084, i16 -309 }, %"struct.rally::TrackPoint" { i16 -3185, i16 4192, i16 -4079, i16 -377 }, %"struct.rally::TrackPoint" { i16 -3249, i16 4185, i16 -4072, i16 -445 }, %"struct.rally::TrackPoint" { i16 -3313, i16 4178, i16 -4064, i16 -513 }, %"struct.rally::TrackPoint" { i16 -3376, i16 4169, i16 -4054, i16 -584 }, %"struct.rally::TrackPoint" { i16 -3439, i16 4160, i16 -4043, i16 -655 }, %"struct.rally::TrackPoint" { i16 -3502, i16 4149, i16 -4031, i16 -728 }, %"struct.rally::TrackPoint" { i16 -3565, i16 4137, i16 -4016, i16 -805 }, %"struct.rally::TrackPoint" { i16 -3628, i16 4124, i16 -3999, i16 -884 }, %"struct.rally::TrackPoint" { i16 -3690, i16 4109, i16 -3980, i16 -968 }, %"struct.rally::TrackPoint" { i16 -3752, i16 4093, i16 -3957, i16 -1058 }, %"struct.rally::TrackPoint" { i16 -3814, i16 4076, i16 -3930, i16 -1154 }, %"struct.rally::TrackPoint" { i16 -3875, i16 4057, i16 -3898, i16 -1259 }, %"struct.rally::TrackPoint" { i16 -3935, i16 4036, i16 -3860, i16 -1371 }, %"struct.rally::TrackPoint" { i16 -3996, i16 4015, i16 -3855, i16 -1384 }, %"struct.rally::TrackPoint" { i16 -4056, i16 3993, i16 -3850, i16 -1399 }, %"struct.rally::TrackPoint" { i16 -4116, i16 3971, i16 -3843, i16 -1418 }, %"struct.rally::TrackPoint" { i16 -4176, i16 3949, i16 -3835, i16 -1440 }, %"struct.rally::TrackPoint" { i16 -4236, i16 3926, i16 -3825, i16 -1464 }, %"struct.rally::TrackPoint" { i16 -4296, i16 3903, i16 -3814, i16 -1493 }, %"struct.rally::TrackPoint" { i16 -4355, i16 3879, i16 -3802, i16 -1525 }, %"struct.rally::TrackPoint" { i16 -4414, i16 3855, i16 -3787, i16 -1561 }, %"struct.rally::TrackPoint" { i16 -4473, i16 3831, i16 -3770, i16 -1602 }, %"struct.rally::TrackPoint" { i16 -4532, i16 3805, i16 -3750, i16 -1647 }, %"struct.rally::TrackPoint" { i16 -4591, i16 3779, i16 -3728, i16 -1698 }, %"struct.rally::TrackPoint" { i16 -4649, i16 3752, i16 -3702, i16 -1753 }, %"struct.rally::TrackPoint" { i16 -4706, i16 3724, i16 -3672, i16 -1815 }, %"struct.rally::TrackPoint" { i16 -4763, i16 3695, i16 -3638, i16 -1882 }, %"struct.rally::TrackPoint" { i16 -4820, i16 3665, i16 -3600, i16 -1954 }, %"struct.rally::TrackPoint" { i16 -4876, i16 3634, i16 -3556, i16 -2033 }, %"struct.rally::TrackPoint" { i16 -4931, i16 3602, i16 -3506, i16 -2117 }, %"struct.rally::TrackPoint" { i16 -4985, i16 3568, i16 -3450, i16 -2207 }, %"struct.rally::TrackPoint" { i16 -5039, i16 3533, i16 -3387, i16 -2303 }, %"struct.rally::TrackPoint" { i16 -5091, i16 3496, i16 -3317, i16 -2403 }, %"struct.rally::TrackPoint" { i16 -5142, i16 3458, i16 -3239, i16 -2507 }, %"struct.rally::TrackPoint" { i16 -5192, i16 3418, i16 -3153, i16 -2615 }, %"struct.rally::TrackPoint" { i16 -5241, i16 3376, i16 -3059, i16 -2724 }, %"struct.rally::TrackPoint" { i16 -5288, i16 3333, i16 -2957, i16 -2834 }, %"struct.rally::TrackPoint" { i16 -5333, i16 3288, i16 -2849, i16 -2943 }, %"struct.rally::TrackPoint" { i16 -5377, i16 3241, i16 -2734, i16 -3050 }, %"struct.rally::TrackPoint" { i16 -5419, i16 3192, i16 -2614, i16 -3154 }, %"struct.rally::TrackPoint" { i16 -5459, i16 3142, i16 -2489, i16 -3253 }, %"struct.rally::TrackPoint" { i16 -5496, i16 3091, i16 -2363, i16 -3346 }, %"struct.rally::TrackPoint" { i16 -5532, i16 3038, i16 -2234, i16 -3433 }, %"struct.rally::TrackPoint" { i16 -5566, i16 2983, i16 -2106, i16 -3513 }, %"struct.rally::TrackPoint" { i16 -5598, i16 2928, i16 -1980, i16 -3586 }, %"struct.rally::TrackPoint" { i16 -5628, i16 2871, i16 -1856, i16 -3651 }, %"struct.rally::TrackPoint" { i16 -5656, i16 2814, i16 -1736, i16 -3710 }, %"struct.rally::TrackPoint" { i16 -5686, i16 2757, i16 -1885, i16 -3636 }, %"struct.rally::TrackPoint" { i16 -5715, i16 2700, i16 -1820, i16 -3669 }, %"struct.rally::TrackPoint" { i16 -5743, i16 2642, i16 -1757, i16 -3700 }, %"struct.rally::TrackPoint" { i16 -5769, i16 2584, i16 -1695, i16 -3729 }, %"struct.rally::TrackPoint" { i16 -5795, i16 2526, i16 -1635, i16 -3756 }, %"struct.rally::TrackPoint" { i16 -5821, i16 2467, i16 -1576, i16 -3781 }, %"struct.rally::TrackPoint" { i16 -5845, i16 2408, i16 -1517, i16 -3805 }, %"struct.rally::TrackPoint" { i16 -5868, i16 2348, i16 -1459, i16 -3827 }, %"struct.rally::TrackPoint" { i16 -5890, i16 2288, i16 -1400, i16 -3849 }, %"struct.rally::TrackPoint" { i16 -5912, i16 2228, i16 -1341, i16 -3870 }, %"struct.rally::TrackPoint" { i16 -5932, i16 2167, i16 -1282, i16 -3890 }, %"struct.rally::TrackPoint" { i16 -5952, i16 2106, i16 -1222, i16 -3910 }, %"struct.rally::TrackPoint" { i16 -5970, i16 2045, i16 -1161, i16 -3928 }, %"struct.rally::TrackPoint" { i16 -5988, i16 1983, i16 -1098, i16 -3946 }, %"struct.rally::TrackPoint" { i16 -6005, i16 1922, i16 -1034, i16 -3963 }, %"struct.rally::TrackPoint" { i16 -6020, i16 1860, i16 -967, i16 -3980 }, %"struct.rally::TrackPoint" { i16 -6035, i16 1797, i16 -899, i16 -3996 }, %"struct.rally::TrackPoint" { i16 -6048, i16 1735, i16 -828, i16 -4011 }, %"struct.rally::TrackPoint" { i16 -6061, i16 1672, i16 -754, i16 -4026 }, %"struct.rally::TrackPoint" { i16 -6072, i16 1609, i16 -677, i16 -4040 }, %"struct.rally::TrackPoint" { i16 -6082, i16 1546, i16 -595, i16 -4053 }, %"struct.rally::TrackPoint" { i16 -6091, i16 1482, i16 -509, i16 -4064 }, %"struct.rally::TrackPoint" { i16 -6098, i16 1419, i16 -419, i16 -4075 }, %"struct.rally::TrackPoint" { i16 -6104, i16 1355, i16 -322, i16 -4083 }, %"struct.rally::TrackPoint" { i16 -6108, i16 1291, i16 -220, i16 -4090 }, %"struct.rally::TrackPoint" { i16 -6110, i16 1227, i16 -110, i16 -4095 }, %"struct.rally::TrackPoint" { i16 -6111, i16 1163, i16 7, i16 -4096 }, %"struct.rally::TrackPoint" { i16 -6110, i16 1099, i16 134, i16 -4094 }, %"struct.rally::TrackPoint" { i16 -6107, i16 1035, i16 271, i16 -4087 }, %"struct.rally::TrackPoint" { i16 -6102, i16 971, i16 418, i16 -4075 }, %"struct.rally::TrackPoint" { i16 -6094, i16 908, i16 579, i16 -4055 }, %"struct.rally::TrackPoint" { i16 -6083, i16 845, i16 753, i16 -4026 }, %"struct.rally::TrackPoint" { i16 -6070, i16 782, i16 942, i16 -3986 }, %"struct.rally::TrackPoint" { i16 -6054, i16 720, i16 1147, i16 -3932 }, %"struct.rally::TrackPoint" { i16 -6034, i16 659, i16 1369, i16 -3861 }, %"struct.rally::TrackPoint" { i16 -6011, i16 600, i16 1606, i16 -3768 }, %"struct.rally::TrackPoint" { i16 -5984, i16 542, i16 1858, i16 -3651 }, %"struct.rally::TrackPoint" { i16 -5956, i16 484, i16 1756, i16 -3701 }, %"struct.rally::TrackPoint" { i16 -5927, i16 427, i16 2001, i16 -3574 }, %"struct.rally::TrackPoint" { i16 -5894, i16 373, i16 2256, i16 -3419 }, %"struct.rally::TrackPoint" { i16 -5856, i16 321, i16 2514, i16 -3233 }, %"struct.rally::TrackPoint" { i16 -5815, i16 272, i16 2769, i16 -3018 }, %"struct.rally::TrackPoint" { i16 -5770, i16 226, i16 3013, i16 -2775 }, %"struct.rally::TrackPoint" { i16 -5721, i16 185, i16 3237, i16 -2509 }, %"struct.rally::TrackPoint" { i16 -5669, i16 148, i16 3436, i16 -2229 }, %"struct.rally::TrackPoint" { i16 -5614, i16 115, i16 3606, i16 -1943 }, %"struct.rally::TrackPoint" { i16 -5556, i16 87, i16 3746, i16 -1658 }, %"struct.rally::TrackPoint" { i16 -5497, i16 64, i16 3856, i16 -1382 }, %"struct.rally::TrackPoint" { i16 -5436, i16 44, i16 3940, i16 -1120 }, %"struct.rally::TrackPoint" { i16 -5374, i16 29, i16 4001, i16 -875 }, %"struct.rally::TrackPoint" { i16 -5311, i16 17, i16 4044, i16 -648 }, %"struct.rally::TrackPoint" { i16 -5248, i16 8, i16 4072, i16 -440 }, %"struct.rally::TrackPoint" { i16 -5184, i16 3, i16 4088, i16 -250 }, %"struct.rally::TrackPoint" { i16 -5120, i16 0, i16 4095, i16 -77 }, %"struct.rally::TrackPoint" { i16 -5056, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 -4992, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 -4928, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 -4864, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 -4800, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 -4736, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 -4672, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 -4608, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 -4544, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 -4480, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 -4416, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 -4352, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 -4288, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 -4224, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 -4160, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 -4096, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 -4032, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 -3968, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 -3904, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 -3840, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 -3776, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 -3712, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 -3648, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 -3584, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 -3520, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 -3456, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 -3392, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 -3328, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 -3264, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 -3200, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 -3136, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 -3072, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 -3008, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 -2944, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 -2880, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 -2816, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 -2752, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 -2688, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 -2624, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 -2560, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 -2496, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 -2432, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 -2368, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 -2304, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 -2240, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 -2176, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 -2112, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 -2048, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 -1984, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 -1920, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 -1856, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 -1792, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 -1728, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 -1664, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 -1600, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 -1536, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 -1472, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 -1408, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 -1344, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 -1280, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 -1216, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 -1152, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 -1088, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 -1024, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 -960, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 -896, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 -832, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 -768, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 -704, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 -640, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 -576, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 -512, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 -448, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 -384, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 -320, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 -256, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 -192, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 -128, i16 0, i16 4096, i16 0 }, %"struct.rally::TrackPoint" { i16 -64, i16 0, i16 4096, i16 0 }], align 1
@.str.14 = private unnamed_addr constant [15 x i8] c"Fuji reference\00", align 1
@.str.15 = private unnamed_addr constant [3 x i8] c"rb\00", align 1
@.str.16 = private unnamed_addr constant [9 x i8] c"ARALLY01\00", align 1
@_ZN12_GLOBAL__N_19carUploadE = internal global [7854 x i8] zeroinitializer, align 1
@__const._ZN12_GLOBAL__N_18loadCarsEv.mirrorCommands = private unnamed_addr constant [34 x i8] c"\17\00\F8\01\00\01\00\17\00\A0\F0\F9 \00\17\00\A0\F0\F9 \0B\C0\FF\FF\00\00e\00\00\00\01\00\00\00", align 1
@_ZN5rallyL9CarPixelsE = internal unnamed_addr constant <{ <{ [2402 x i8], [670 x i8] }>, <{ [2405 x i8], [667 x i8] }>, <{ [2457 x i8], [615 x i8] }>, <{ [2520 x i8], [552 x i8] }>, <{ [2524 x i8], [548 x i8] }> }> <{ <{ [2402 x i8], [670 x i8] }> <{ [2402 x i8] c"\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\C3\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\C3\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\C0\C0\C0\C0\C0\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\C0\C0\C0\C0\C0\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\C0\C0\C0\C0\C0\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\C0\C0\C0\C0\C0\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\C0\C0\C0\C0\C0\EF\EF\EF\EF\EF\EF\EF\EF\C2\C2\CF\CF\C2\C2\EF\EF\EF\EF\EF\EF\EF\EF\C0\C0\C0\C0\C0\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\EA\C0\C0\C0\C0\C0\EF\EF\EF\EF\EF\EF\EF\C2\C2\F8\F8\F8\F8\C2\C2\EF\EF\EF\EF\EF\EF\EF\C0\C0\C0\C0\C0\EA\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\EA\C0\C0\C0\C0\C0\00\00\00\00\00\00\C2\C2\F8\F8\F8\F8\F8\F8\C2\C2\00\00\00\00\00\00\C0\C0\C0\C0\C0\EA\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\EA\C0\C0\C0\C0\C0\EA\EA\EA\EA\00\C2\C2\C0\F8\F8\F8\F8\F8\F8\C0\C2\C2\00\EA\EA\EA\EA\C0\C0\C0\C0\C0\EA\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\C3\00\EA\C0\C0\C0\C0\C0\00\00\00\00\00\C2\C2\C0\F8\D0\D0\D0\D0\F8\C0\C2\C2\00\00\00\00\00\C0\C0\C0\C0\C0\EA\00\C3\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\C3\00\00\C0\C0\C0\C0\C7\C7\C7\C7\C7\C2\C2\C2\C0\D5\D5\D5\D5\D5\D5\C0\C2\C2\C2\C7\C7\C7\C7\C7\C0\C0\C0\C0\00\00\C3\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\C3\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\C3\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\C3\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\C3\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\C3\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\C3\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\C3\EF\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\EF\C3\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\C3\C0\C0\C0\C0\C0\C0\C0\C0\C7\C7\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C7\C7\C0\C0\C0\C0\C0\C0\C0\C0\C3\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\C3\C0\C0\C0\C0\C0\C0\C0\C0\C7\C7\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C7\C7\C0\C0\C0\C0\C0\C0\C0\C0\C3\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\EA\C0\C0\C0\C0\C0\C0\C0\C0\C7\C7\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C7\C7\C0\C0\C0\C0\C0\C0\C0\C0\EA\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\EA\C0\C0\C0\C0\C0\C0\C0\C0\C3\C3\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C0\C0\C0\C0\C0\C0\C0\C0\EA\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\EA\C0\C0\C0\C0\C0\C0\C0\C0\C3\C3\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C3\C2\C2\C0\C0\C0\C0\C0\C0\C0\C0\EA\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\EA\C0\C0\C0\C0\C0\C0\C0\C0\C3\C3\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C3\C2\C2\C0\C0\C0\C0\C0\C0\C0\C0\EA\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\EA\C0\C0\C0\C0\C0\C0\C0\C0\C3\C3\C2\C2\C2\C2\EA\EA\C2\C2\C2\C2\EA\EA\C2\C2\C2\C3\C2\C2\C0\C0\C0\C0\C0\C0\C0\C0\EA\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\C0\C0\C0\C0\C0\C0\C0\C0\C3\C3\C2\C2\C2\C2\EA\EA\C2\C2\C2\C2\EA\EA\C2\C2\C2\C3\C2\C2\C0\C0\C0\C0\C0\C0\C0\C0\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\C0\C0\C0\C0\C0\C0\C0\C0\C3\C3\C2\C2\C2\C2\C2\C2\D5\D5\D5\D5\C2\C2\C2\C2\C2\C3\C2\C2\C0\C0\C0\C0\C0\C0\C0\C0\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\C0\C0\C0\C0\C0\C0\C0\C0\00\00\C2\C2\C2\C2\C2\C2\D5\D5\D5\D5\C2\C2\C2\C2\C2\C3\00\00\C0\C0\C0\C0\C0\C0\C0\C0\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\C0\C0\C0\C0\C0\C0\C0\C0\00\00\00\C2\C2\C2\C2\C2\D5\D5\D5\D5\C2\C2\C2\C2\C2\00\00\00\C0\C0\C0\C0\C0\C0\C0\C0\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\D5\D5\D5\D5", [670 x i8] zeroinitializer }>, <{ [2405 x i8], [667 x i8] }> <{ [2405 x i8] c"\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\C0\C0\C0\C0\C0\C0\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\C0\C0\C0\C0\C0\C0\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\EF\EF\EF\EF\EF\EF\C0\C0\C0\C0\C0\C0\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\C0\C0\C0\C0\C0\C0\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\C0\C0\C0\C0\C0\C0\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\C0\C0\C0\C0\C0\C0\C0\EF\EF\EF\EF\EF\EF\C2\C2\CF\CF\C2\C2\EF\EF\EF\EF\EF\EF\EF\EF\C0\C0\C0\C0\C0\C0\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\C0\C0\C0\C0\C0\C0\C0\EF\EF\EF\EF\EF\EF\C2\C2\C2\CF\F8\F8\F8\F8\F8\EF\EF\EF\EF\EF\C0\C0\C0\C0\C0\C0\C0\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\EA\C0\C0\C0\C0\C0\C0\EF\EF\EF\EF\EF\EF\C2\C2\C2\C2\F8\F8\F8\F8\F8\C2\00\00\00\00\EA\C0\C0\C0\C0\C0\C0\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\EA\C0\C0\C0\C0\C0\C0\00\EA\EA\00\00\C2\C2\C2\C2\F8\F8\F8\F8\F8\F8\F8\C2\EA\EA\EA\EA\C0\C0\C0\C0\C0\C0\00\00\00\00\00\C3\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\EA\C0\C0\C0\C0\C0\C0\EA\EA\EA\00\00\C2\C2\C0\C0\F8\D0\D0\D0\D0\D0\C0\C2\C2\C2\C7\C7\C7\C7\C0\C0\C0\C0\00\00\00\00\00\C3\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\EA\C0\C0\C3\C0\C0\C3\C7\C7\C7\C7\C7\C2\C2\C2\C0\C0\D5\D5\D5\D5\D5\D5\C0\C2\C2\C7\C7\C7\C7\C2\C0\C0\EF\EF\EF\EF\EF\EF\C3\C3\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\C0\C0\C0\C3\C0\C0\C3\C7\C7\C7\C7\C7\C2\C2\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\C3\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\C0\C0\C3\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\C3\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\C0\C0\C3\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\EF\C3\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\C0\C0\C3\EF\EF\EF\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C0\C0\C0\C0\C0\00\C3\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\C0\C3\EF\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\D5\C2\C2\C2\C2\C2\C2\C2\C2\C2\D5\C2\C2\C7\C0\C0\C0\C0\C0\C0\C0\C0\C0\C0\C3\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\C0\C3\C0\C0\C0\C0\C0\C0\C0\C7\C2\C2\C2\C2\D5\C2\C2\C2\C2\C2\C2\C2\C2\C2\D5\C2\C2\C7\C7\C0\C0\C0\C0\C0\C0\C0\C0\C0\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\C0\C3\C0\C0\C0\C0\C0\C0\C0\C7\C7\C2\C2\C2\D5\C2\C2\C2\C2\C2\C2\C2\C2\C2\D5\C2\C2\C7\C7\C0\C0\C0\C0\C0\C0\C0\C0\C0\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\EA\C0\C0\C0\C0\C0\C0\C0\C0\C7\C7\C2\C2\C2\D5\C2\C2\C2\C2\C2\C2\C2\C2\C2\D5\C2\C2\C2\C2\C0\C0\C0\C0\C0\C0\C0\C0\C0\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\EA\C0\C0\C0\C0\C0\C0\C0\C0\C3\C3\C2\C2\C2\D5\C2\C2\C2\C2\C2\C2\C2\C2\C2\D5\C2\C2\C2\C2\C0\C0\C0\C0\C0\C0\C0\C0\C0\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\EA\C0\C0\C0\C0\C0\C0\C0\C0\C3\C3\C2\C2\C2\D5\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C0\C0\C0\C0\C0\C0\C0\C0\C0\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\EA\C0\C0\C0\C0\C0\C0\C0\C0\C3\C3\C2\C2\C2\C2\C2\EA\EA\C2\C2\C2\C2\EA\EA\C2\C2\C2\C2\C2\C0\C0\C0\C0\C0\C0\C0\C0\C0\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\EA\C0\C0\C0\C0\C0\C0\C0\C0\C3\C3\C2\C2\C2\C2\C2\EA\EA\C2\D5\D5\D5\EA\EA\C2\C2\C2\C2\C2\C0\C0\C0\C0\C0\C0\C0\C0\C0\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\C0\C0\C0\C0\C0\C0\C0\C0\C0\C3\C3\C2\C2\C2\C2\C2\C2\D5\D5\D5\D5\D5\C2\C2\C2\C2\C2\00\00\C0\C0\C0\C0\C0\C0\C0\C0\C0\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\C0\C0\C0\C0\C0\C0\C0\C0\C0\00\00\00\C2\C2\C2\C2\C2\D5\D5\D5\D5\D5\C2\C2\C2\C2\C2\00\00\C0\C0\C0\C0\C0\C0\C0\C0\C0\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\C0\C0\C0\C0\C0\C0\C0\C0\C0\00\00\00\C2\C2\C2\C2\C2\D5\D5\D5\D5\D5\C2\C2\C2\00\00\00\00\C0\C0\C0\C0\C0\C0\C0\C0\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\C0\C0\C0\C0\C0\C0\C0\C0\00\00\00\00\00\00\00\00\00\D5\D5\D5\D5", [667 x i8] zeroinitializer }>, <{ [2457 x i8], [615 x i8] }> <{ [2457 x i8] c"\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\C3\C0\C0\C0\C0\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\C0\C0\C0\C0\C0\C0\C0\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\EF\EF\EF\EF\EF\EF\EF\C0\C0\C0\C0\C0\C0\C0\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\C3\00\C0\C0\C0\C0\C0\00\00\00\00\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\C0\C0\C0\C0\C0\C0\C0\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\C3\C0\C0\C0\C0\C0\C0\C0\EF\EF\EF\EF\EF\C2\C2\CF\CF\C2\C2\C2\EF\EF\EF\EF\EF\EF\EF\C0\C0\C0\C0\C0\C0\C0\C0\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\C3\C0\C0\C0\C0\C0\C0\C0\EF\EF\EF\EF\EF\C2\C2\C2\CF\CF\CF\C2\C2\F8\F8\F8\F8\EF\EF\C0\C0\C0\C0\C0\C0\C0\C0\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\C3\C0\C0\C0\C0\C0\C0\C0\EF\EF\EF\EF\EF\C2\C2\C2\C2\C2\CF\CF\F8\F8\F8\F8\F8\F8\EA\EA\C0\C0\C0\C0\C0\C0\C0\00\00\00\00\00\00\00\00\00\C3\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\EA\C0\C0\C0\C0\C0\C0\C0\EF\00\00\00\C2\C2\C2\C2\C2\C2\C2\F8\F8\F8\F8\F8\F8\C2\C0\C0\C0\C0\C0\C0\C0\C0\00\00\00\00\00\00\00\00\00\C3\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\EA\EA\C0\C0\C0\C0\C0\C0\EA\EA\00\00\00\C2\C2\C2\C0\C0\C0\F8\D0\D0\D0\D0\D0\C2\C2\C7\C7\C7\C7\C7\C0\C0\00\00\00\00\00\EF\EF\EF\EF\C3\C3\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\EA\EA\C0\C0\C0\C0\C0\C0\00\00\00\00\00\C2\C2\C2\C2\C0\C0\F8\D5\D5\D5\D5\D5\D5\C2\C2\C7\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\C3\C3\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\C0\EA\C0\C0\C0\C0\C0\C3\C3\C7\C7\C7\C7\C7\C2\C2\C2\C0\C0\C0\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\C3\C3\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\C0\C0\C0\C0\C0\C0\C0\C3\C3\C7\C7\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\C2\C2\C2\C2\C2\C2\C2\C2\C3\C3\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\C0\C0\C0\C0\C0\C0\C3\C3\C3\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C0\C0\C0\00\C3\C3\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\C0\C0\C0\C0\C0\C0\C3\C3\C3\EF\EF\EF\EF\EF\EF\EF\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C7\C0\C0\C0\C0\C0\C0\C0\C0\C0\C0\00\00\C3\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\C0\C3\C3\C3\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\D5\C2\C7\C7\C0\C0\C0\C0\C0\C0\C0\C0\C0\C0\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\C0\C0\C0\C3\C3\C2\C2\C0\C0\C0\C0\C2\C2\C2\C2\D5\D5\C2\C2\C2\C2\C2\C2\C2\C2\D5\C2\C7\C7\C7\C0\C0\C0\C0\C0\C0\C0\C0\C0\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\C0\C0\C0\C3\C3\C0\C0\C0\C0\C0\C0\C2\C2\C2\C2\D5\D5\C2\C2\C2\C2\C2\C2\C2\C2\D5\C2\C2\C2\C2\C0\C0\C0\C0\C0\C0\C0\C0\C0\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\C0\C0\C0\C0\C3\C0\C0\C0\C0\C0\C0\C7\C2\C2\C2\D5\D5\C2\C2\C2\C2\C2\C2\C2\C2\D5\C2\C2\C2\C2\C0\C0\C0\C0\C0\C0\C0\C0\C0\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\C0\EA\C0\C0\C0\C0\C0\C0\C0\C0\C0\C3\C3\C2\C2\D5\D5\C2\C2\C2\C2\C2\C2\C2\C2\D5\C2\C2\C2\C2\C0\C0\C0\C0\C0\C0\C0\C0\C0\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\C0\EA\C0\C0\C0\C0\C0\C0\C0\C0\C0\C3\C3\C2\C2\C2\D5\C2\C2\C2\C2\C2\C2\C2\EA\C2\C2\C2\C2\C2\C0\C0\C0\C0\C0\C0\C0\C0\C0\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\C0\EA\C0\C0\C0\C0\C0\C0\C0\C0\C0\C3\C3\C2\C2\C2\C2\C2\EA\EA\C2\C2\C2\C2\EA\EA\C2\C2\C2\C2\C0\C0\C0\C0\C0\C0\C0\C0\C0\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\C0\EA\EA\C0\C0\C0\C0\C0\C0\C0\C0\C3\C3\C2\C2\C2\C2\C2\EA\EA\D5\D5\D5\D5\C2\C2\C2\C2\00\C0\C0\C0\C0\C0\C0\C0\C0\C0\C0\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\EA\C0\C0\C0\C0\C0\C0\C0\C0\C0\C3\C3\C2\C2\C2\C2\C2\C2\D5\D5\D5\D5\D5\C2\C2\C2\C2\00\C0\C0\C0\C0\C0\C0\C0\C0\C0\C0\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\C0\C0\C0\C0\C0\C0\C0\C0\C0\C0\00\00\C2\C2\C2\C2\C2\C2\D5\D5\D5\D5\D5\C2\C2\C2\C2\00\00\C0\C0\C0\C0\C0\C0\C0\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\C0\C0\C0\C0\C0\C0\C0\C0\C0\C0\00\00\00\C2\C2\C2\C2\C2\D5\D5\D5\D5\D5\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\C0\C0\C0\C0\C0\C0\C0\C0\C0\C0\00\00\00\00\00\00\00\00\00\D5\D5\D5\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\C0\C0\C0\C0\C0\C0\C0", [615 x i8] zeroinitializer }>, <{ [2520 x i8], [552 x i8] }> <{ [2520 x i8] c"\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\C3\C0\C0\C0\C0\C0\C0\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\EF\C0\C0\C0\C0\C0\C0\C0\C0\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\EF\EF\EF\EF\EF\EF\C0\C0\C0\C0\C0\C0\C0\C0\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\C0\C0\C0\C0\C0\C0\C0\C0\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\C0\C0\C0\C0\C0\EF\EF\EF\EF\EF\EF\C2\C2\C2\C2\EF\EF\EF\EF\EF\EF\EF\EF\C0\C0\C0\C0\C0\C0\C0\C0\C0\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\C3\C3\C0\C0\C0\C0\C0\C0\C0\C0\EF\EF\EF\C2\C2\C2\CF\CF\CF\C2\C2\C2\C2\EF\F8\F8\F8\F8\F8\C0\C0\C0\C0\C0\C0\C0\00\00\00\00\00\00\00\00\00\00\00\00\C3\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\C3\C3\C0\C0\C0\C0\C0\C0\C0\C0\EF\EF\EF\EF\C2\C2\C2\C2\CF\CF\CF\C2\C2\C2\F8\F8\F8\F8\F8\C0\C0\C0\C0\C0\C0\C0\00\00\00\00\00\00\00\00\00\00\00\00\C3\C3\00\00\00\00\00\00\00\00\00\00\00\00\00\00\C3\C3\C0\C0\C0\C0\C0\C0\C0\C0\EF\EF\EF\EF\C2\C2\C2\C2\C2\C2\C2\CF\C2\F8\F8\F8\F8\F8\D0\D0\C0\C2\C7\C7\C0\C0\00\00\00\00\00\00\00\00\EF\EF\EF\EF\EF\C3\C3\00\00\00\00\00\00\00\00\00\00\00\00\00\00\C3\C0\EA\C0\C0\C0\C0\C0\C0\C0\00\00\00\C2\C2\C2\C2\C2\C2\C0\C0\C0\F8\F8\D0\D0\D0\D0\D0\D5\C7\C7\C7\C7\C0\00\00\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\C3\C3\00\00\00\00\00\00\00\00\00\00\00\00\00\00\C0\EA\C0\C0\C0\C0\C0\C0\C0\EA\EA\00\00\C2\C2\C2\C2\C2\C0\C0\C0\C0\D5\D5\D5\D5\D5\D5\D5\C2\C2\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\C2\EF\C3\00\00\00\00\00\00\00\00\00\00\00\00\00\00\C0\EA\EA\C0\C0\C0\C0\C0\C0\00\00\00\C7\C7\C7\C2\C2\C2\C2\C0\C0\C0\D5\D5\D5\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\C2\C2\C2\C2\C2\C2\C2\EF\C3\00\00\00\00\00\00\00\00\00\00\00\00\00\00\C0\EA\EA\C0\C0\C0\C0\C0\C0\00\C3\C7\C3\C3\C7\C7\C2\C2\C2\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\C2\C2\C2\C2\C2\C2\C2\C2\C2\C0\C0\C0\00\C3\C3\00\00\00\00\00\00\00\00\00\00\00\00\00\00\C0\C0\C0\C0\C0\C0\C0\C0\C0\00\C3\C3\C3\C3\C3\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\C2\C2\C2\C2\C2\C2\C2\C2\C2\C0\C0\C0\C0\C0\C0\C0\C0\C0\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\C0\C0\C0\C0\C0\C0\C0\C0\00\C3\C3\C3\C3\C3\C3\EF\EF\EF\EF\EF\EF\EF\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\D5\D5\C7\C0\C0\C0\C0\C0\C0\C0\C0\C0\C0\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\C0\C0\C0\C0\C0\C0\C0\00\00\C0\C0\C3\C3\C3\C3\EF\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\D5\D5\C7\C7\C0\C0\C0\C0\C0\C0\C0\C0\C0\C0\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\C0\C0\C0\C3\C3\C3\C3\C2\C2\C2\C2\C2\C2\C2\C2\C2\D5\C2\C2\C2\C2\C2\C2\C2\C2\D5\D5\C7\C2\C0\C0\C0\C0\C0\C0\C0\C0\C0\C0\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\C0\C0\C0\C0\C3\C3\C3\C0\C0\C0\C0\C2\C2\C2\C2\C2\D5\C2\C2\C2\C2\C2\C2\C2\C2\D5\D5\C2\C2\C2\C0\C0\C0\C0\C0\C0\C0\C0\C0\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\C0\C0\C0\C0\C0\C3\C3\C0\C0\C0\C0\C0\C2\C2\C2\C2\D5\C2\C2\C2\C2\C2\C2\C2\C2\D5\D5\C2\C2\C2\C0\C0\C0\C0\C0\C0\C0\C0\C0\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\C0\EA\C0\C0\C0\C0\C0\C0\C0\C0\C0\C0\C3\C2\C2\C2\D5\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C0\C0\C0\C0\C0\C0\C0\C0\C0\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\C0\EA\EA\C0\C0\C0\C0\C0\C0\C0\C0\C0\C3\C2\C2\C2\D5\C2\C2\C2\C2\C2\C2\C2\EA\EA\C2\C2\C2\C2\C0\C0\C0\C0\C0\C0\C0\C0\C0\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\C0\EA\EA\C0\C0\C0\C0\C0\C0\C0\C0\C0\C3\C2\C2\C2\C2\C2\C2\EA\EA\C2\C2\C2\C2\EA\C2\C2\C2\C0\C0\C0\C0\C0\C0\C0\C0\C0\C0\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\C0\EA\EA\C0\C0\C0\C0\C0\C0\C0\C0\C0\C3\C2\C2\C2\C2\C2\C2\EA\EA\D5\D5\D5\D5\C2\C2\C2\C2\C0\C0\C0\C0\C0\C0\C0\C0\C0\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\C0\EA\EA\C0\C0\C0\C0\C0\C0\C0\C0\C0\C3\C2\C2\C2\C2\C2\C2\C2\D5\D5\D5\D5\D5\C2\C2\C2\C2\C0\C0\C0\C0\C0\C0\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\C0\EA\C0\C0\C0\C0\C0\C0\C0\C0\C0\00\C2\C2\C2\C2\C2\C2\C2\D5\D5\D5\D5\D5\C2\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\C0\C0\C0\C0\C0\C0\C0\C0\C0\C0\C0\00\00\C2\C2\C2\C2\C2\C2\D5\D5\D5\D5\D5\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\C0\C0\C0\C0\C0\C0\C0\C0\C0\C0\C0\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\C0\C0\C0\C0\C0\C0\C0\C0\C0\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\C0\C0\C0", [552 x i8] zeroinitializer }>, <{ [2524 x i8], [548 x i8] }> <{ [2524 x i8] c"\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\C0\C0\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\C3\C3\C0\C0\C0\C0\C0\C0\C0\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\EF\C0\C0\C0\C0\C0\C0\C0\C0\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\EF\EF\EF\EF\EF\EF\C0\C0\C0\C0\C0\C0\C0\C0\C0\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\C0\C0\C0\C0\C0\C0\C0\C0\C0\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\C0\C0\C0\C0\C0\C0\C0\C0\C0\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\C3\C3\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\C0\C0\C0\C0\C0\EF\EF\EF\C2\C2\CF\CF\CF\C2\C2\C2\C2\EF\EF\EF\00\F8\F8\F8\F8\F8\C0\C0\C0\C0\C0\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\C3\C3\C3\00\00\00\00\00\00\00\00\00\00\C3\00\00\C0\C0\C0\C0\C0\C0\C0\C0\EF\EF\C2\C2\C2\C2\C2\CF\CF\CF\C2\C2\C2\C2\C2\F8\F8\F8\F8\F8\C0\C0\C0\C0\C0\00\00\00\00\00\00\00\00\00\00\00\EF\EF\EF\EF\EF\EF\C3\C3\C3\00\00\00\00\00\00\00\00\C3\C3\C0\C0\C0\C0\C0\C0\C0\C0\C0\EF\EF\C2\C2\C2\C2\C2\C2\C2\C2\CF\CF\C2\C2\C2\F8\F8\F8\F8\D0\D0\C7\C7\C7\C7\00\00\00\00\00\00\00\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\C3\C3\00\00\00\00\00\00\00\00\C3\C3\C0\C0\C0\C0\C0\C0\C0\C0\C0\C0\EF\C2\C2\C2\C2\C2\C2\C2\C2\C2\C0\C0\C0\C0\F8\F8\D0\D0\D0\D5\D5\D5\C7\C7\C7\00\00\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\C2\C2\C2\C3\C3\00\00\00\00\00\00\00\00\00\C3\C0\C0\EA\C0\C0\C0\C0\C0\C0\C0\EA\00\C2\C2\C2\C2\C2\C2\C2\C2\C0\C0\C0\C0\F8\D5\D5\D5\D5\D5\D5\D5\C2\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\C2\C2\C2\C2\C2\C2\C3\C3\C3\00\00\00\00\00\00\00\00\00\00\C0\EA\EA\EA\C0\C0\C0\C0\C0\C0\EA\00\00\C2\C2\C2\C2\C2\C2\C2\C2\C2\C0\C0\C0\D5\D5\D5\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\C2\C2\C2\C2\C2\C2\C0\C0\C0\00\00\C3\C3\00\00\00\00\00\00\00\00\00\00\C0\C0\EA\EA\C0\C0\C0\C0\C0\C0\00\00\C3\C7\C7\C7\C7\C3\C2\C2\C2\C2\C2\C0\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\C2\C2\C2\C2\C2\C2\C0\C0\C0\C0\C0\C0\C0\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\C0\EA\EA\C0\C0\C0\C0\C0\C0\00\00\C3\C7\C7\C7\C7\C3\C3\C3\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\EF\C2\C2\C2\C2\C2\C2\C2\D5\C0\C0\C0\C0\C0\C0\C0\C0\C0\C0\C0\00\00\00\00\00\00\00\00\00\00\00\00\00\00\C0\C0\C0\C0\C0\C0\C0\C0\C0\00\00\C3\C3\C3\C7\C7\C3\C3\C3\C3\EF\EF\EF\EF\EF\EF\EF\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\D5\D5\C0\C0\C0\C0\C0\C0\C0\C0\C0\C0\C0\00\00\00\00\00\00\00\00\00\00\00\00\00\00\C0\C0\C0\C0\C0\C0\C0\C0\C0\00\00\C3\C3\C3\C3\C7\C3\C3\C3\C3\C3\EF\EF\C2\C2\C2\C2\C2\C2\D5\C2\C2\C2\C2\C2\C2\C2\D5\D5\C7\C0\C0\C0\C0\C0\C0\C0\C0\C0\C0\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\C0\C0\C0\C0\C0\C0\C0\00\00\00\C3\C3\C0\C0\C0\C3\C3\C3\C3\C3\C2\C2\C2\C2\C2\C2\C2\D5\D5\C2\C2\C2\C2\C2\C2\C2\D5\D5\C2\C2\C0\C0\C0\C0\C0\C0\C0\C0\C0\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\C0\C0\00\00\00\00\00\00\00\C3\C0\C0\C0\C0\C0\C3\C3\C3\C3\C0\C0\C0\C2\C2\C2\C2\D5\D5\C2\C2\C2\C2\C2\C2\C2\D5\D5\C2\C2\C0\C0\C0\C0\C0\C0\C0\C0\C0\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\C0\C0\C0\C0\C0\C0\C0\C3\C3\C0\C0\C0\C2\C2\C2\C2\D5\D5\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C2\C0\C0\C0\C0\C0\C0\C0\C0\C0\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\C0\C0\C0\C0\C0\C0\C0\C0\C0\C0\C0\C0\C0\C2\C2\C2\D5\D5\C2\C2\C2\C2\C2\C2\C2\EA\EA\C2\C2\C0\C0\C0\C0\C0\C0\C0\C0\C0\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\C0\C0\EA\C0\C0\C0\C0\C0\C0\C0\C0\C0\C0\C2\C2\C2\C2\C2\C2\C2\EA\C2\C2\C2\C2\EA\EA\C2\C2\C0\C0\C0\C0\C0\C0\C0\C0\C0\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\C0\EA\EA\EA\C0\C0\C0\C0\C0\C0\C0\C0\C0\C2\C2\C2\C2\C2\C2\C2\EA\EA\D5\D5\D5\C2\C2\C2\C2\C0\C0\C0\C0\C0\C0\C0\C0\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\C0\C0\EA\EA\C0\C0\C0\C0\C0\C0\C0\C0\C0\C2\C2\C2\C2\C2\C2\C2\D5\D5\D5\D5\D5\D5\C2\C2\C2\C0\C0\C0\C0\C0\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\C0\C0\EA\EA\C0\C0\C0\C0\C0\C0\C0\C0\C0\C2\C2\C2\C2\C2\C2\C2\D5\D5\D5\D5\D5\D5\C2\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\C0\C0\EA\EA\C0\C0\C0\C0\C0\C0\C0\C0\C0\C2\C2\C2\C2\C2\C2\C2\D5\D5\D5\D5\D5\D5\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\C0\C0\C0\C0\C0\C0\C0\C0\C0\C0\C0\C0\00\00\C2\C2\C2\C2\00\00\D5\D5\D5\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\C0\C0\C0\C0\C0\C0\C0\C0\C0\C0\C0\C0\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\C0\C0\C0\C0\C0\C0\C0\C0\C0\C0\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\C0\C0\C0\C0\C0", [548 x i8] zeroinitializer }> }>, align 1
@_ZZN5rally9carColourEhjE7colours = linkonce_odr dso_local local_unnamed_addr constant [6 x [6 x i8]] [[6 x i8] c"\E0\F0\F4\C7\DB\CF", [6 x i8] c"\C4\C4\C8\C3\EB\FF", [6 x i8] c"\CA\CF\DF\F2\F6\F0", [6 x i8] c"\E8\FC\FD\C3\D7\FF", [6 x i8] c"\E6\F6\FB\CF\DF\C4", [6 x i8] c"\C6\C7\CB\F4\F9\FC"], align 1
@_ZN5rallyL13SceneryPixelsE = internal constant [53248 x i8] c"\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\04DD\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00DD@\00DDDDD@\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\04DDDDDDDDDDD\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\04DDDD\00\00\00\00\00\00\00\00\00DDDDDDDDDDDDD\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00DDDDDDD@\00\00\00\00\00\00\04DDDDDDDDDDDDDD@\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\04DDDDDDDD\00\00\00\00\00\00\04DDDDD4CDDDDDDDD@\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\04DDD\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\04DDDDDDDD0\00DDDDCDDDDC3C4DDDDDD4D\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\04DDDDD\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\03DDDDDDDC3DDDDDDDDDD33C333DDDC3D@\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00DDDDDD@\00\00\00\00DDDDDD@\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\0034DDDD334DDDDDDDDDC33DD334DD34DC\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00DDDDDDDD@\00\00\00DDDDDDDDD\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\0333333DDDDDDDDDD3334DDDD3333DD30\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\04DDDDDDDDC4DDDDDDDDDDDD\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\04DDDDDDDDDDDDDDDD333DDDDD3DDDDC30\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00DDDDDDDDD34DDDDDDDDDDDD0\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\04DDDDDDDDDDDDDDDDC33DDDDDD33DDC330\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00DDDDCDDDDCDDDDDDDDDDDD33\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\04DDDDDDDDDD4DDDDD33DDDDDDDC3333330\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00DDDDDC4DDDDDDDDDDDDDDC330\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\034DDDDDDDD33DDDC333DDDDC4DD3333333\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\04DD4DDD34DDDC3DDDDDDDDC30\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\04DDDDDDD\00\00\00\00\00\04DDD\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\0033DDDDDC3333333333DDDC333DD333330\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00DDD3DDC34DDDDC34DDDDD333\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00DDDDDDDDDD\00\00\00\04DDDDD\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\03333333033333333333333333333333\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\04DDDC3333DDDDDDDC3333333\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\04DDDDDDDDDDD\00\00DDDDDD@\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00333330\00\00\033333\00\003333330\00333330\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\04DDDDC33DD3DDDDDDDDDC30\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00DDDDDDDDDDDD\00\04DDDDDDD\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\033333\00\00\00\00\00\00\00\00\00\00\0033330\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\03DDDDDDDDC4DDDDDDDDDD\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\04DDDDDDDDD4D4DDDDDDDD0\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\0333\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\034DDDDDDD33DDDDDDDDDC0\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00DDDDDDDDDC4DDDDD333CDDDDDDC3\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00DD@\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\0333DDDDC3334DDDDDDDD33\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\04DDDDDDDDDDD33DDDC334C4DDDDD33\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\04DDDD\00DDDD@\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00333333333433DDDDDC330\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00DDDDDDDDDDDDC34DD333DC34DDD333\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\04DDDDDDDDDDDD\00\00\00\00\00\04DD\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\003333333333333333333\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00DDDDDDDCDDDDDD33334D3333333330\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00DDD@\04DDDD\00\00\00\00DDDDDDDDDDDDD@\00\00\00\04DDDD\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\033333\00\00\0333333333\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\04DDDDDDDD4DDDDDD333333\00\03333333\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\04DDDDDDDDDDDD\00\04DDDDDDDDDDDDDC\00\00\00DDDDD@\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00DDDDDDDDDCDDDDDD33\00\00\00\00\00\00\003330\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00DDDDDDDDDDDDDD\04DDDDDDDDDD4DD30\00\04DDDDDD\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00DDDDDDDDD3DDDDDD3\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00DDDDDDDDDDDDDDCDDDDDDDDDC3DC30\00\04DDDDDD0\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\004DDCDDDDC34DDDDC3\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\004DDDDDDDDDDDDDC4DDDDDDDD33C330\00\03DDDDDC3\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\003DDD3DDC333DDDC33\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\033DDDDDDDDDDDDC334DDDD3333333\00\00C4DDDD33\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00334DD33333333333\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\0034DDDDDDD4DD3333DDC33333330\04DC34DD333\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\03333333333\00\03333\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\03DDDDDDC3D33034DDD3333330\04DDD3333330\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\033333333\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\0034DDD334333\00\00DDDDC3\00\00\00\00\00DDDDC33333\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\0033330\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\033333DC33\00\00\04DDDDD\00\00\00\00\00\00DDDDDC333\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\034DDD33\00\00\00\04DDDDD0\00\00\00\00\004DDDDDD30\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\033DDC33\00\00\00\03DDDDC3\00\00\00\00\00\034CDDDC30\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00333330\00\00\00\034DDD33\00\00\00\00\00\00\0333DC33\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\033333\00\00\00\00\033DDC33\00\00\00\00\00\00\00\0033330\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\0333\00\00\00\00\00\00333330\00\00\00\00\00\00\00\00\03333\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\033333\00\00\00\00\00\00\00\00\00\00330\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\0333\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\04\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\05D@\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\05TDD\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00UUDDD@\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00UUTDDDD\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\05UTDDDDDE\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00UUDDDDDDDP\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\07UTDDDDDDDE\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00uUDDDDTDDDDP\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\07UUDDDDuDDDDE\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00uUTDDDGwDDDDDP\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\07uUTDDDGwtDDEUE\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00wUUDDDDwwtDDEUUP\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\07uUUDDDDwwwtDDUUU\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00wUUTDETGwwwwUDUUUP\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00wwUUTDUUGwwwwuUEUUU\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00wwuUUDUUWwwwwwwUUUUUP\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00wwwUUUEUUwwwwwwwuUUUUU\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\07wwwuUUTUUWwwwwwwwwUUUUUP\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\07wwwwuUUUUUWwwwwwwwwuUUUUUP\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\07wwwwwUUUUUUwwwwwwwwwwUUUUUUP\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\07wwwwwuUUUUUWwwwwwwwwwwuUUUUUUP\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00wwwwwwUUUUWwwwwwwwwwwwwwwuUUUUU\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00wwwwwwwUUUwwwwwwwwwwwwwwwwwwwUUUU\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\07wwwwwwuUwwwwwwwwwwwwwwwwwwwwwwwUUU\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00wwwwwwwWwwwwwwwwwwwwwwwwwwwwwwwwwwuU\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwU\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\07wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00wwwx\88\87wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww\88wwp\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\08\88\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\08\88\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\08\80\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\88\88\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\08\88\80\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\08\88\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\08\88\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\88\88\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\07www\88\88\88\87wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww\88\88\88wwp\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\08\88\88\88\88\88\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\08\88\88\88\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\08\88\88\88\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\08\88\88\88\88\88\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\08\88\88\80\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\88\88\88\80\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\88\00\00\08\88\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\88\88\88\80\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\08\88\80\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\08\88\88\88\88\88\80\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\88\88\00\00\00\00\00\00\00\00\08\88\80\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\88\88\88\88\88\88\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\88\88\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\88\88\88\80\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\08\88\00\00\08\80\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00wwwwx\88\88\88\88\88\88\88wwwwwwwwwwwwwwwwwwwx\88\87www\88\88\88\88\88\88\88\87wwp\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\08\88\88\88\88\88\88\80\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\08\00\00\00\00\00\00\00\00\88\88\88\88\80\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\88\88\88\88\80\00\00\00\00\00\00\00\08\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\88\88\88\88\88\88\88\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\88\88\88\88\88\88\88\80\00\00\00\88\88\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\08\88\88\88\88\88\88\88\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\88\88\88\88\88\88\88\00\00\00\88\88\80\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\88\88\88\88\88\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\08\88\88\88\80\00\00\08\88\80\00\08\88\88\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\88\88\88\88\88\88\88\80\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\08\88\88\88\00\00\08\88\00\00\08\88\88\88\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\88\88\88\88\88\88\88\80\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\08\88\88\00\00\88\88\00\00\00\88\88\88\88\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\08\88\88\88\88\80\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\88\88\80\00\00\08\88\88\88\88\88\88\80\00\00\00\00\00\00\00\00\00\00\00\00wwwwww\88\88\88\88\88\88\88\88\87wwx\88\88wwwwwwwwwwwwx\88\88\88\87w\88\88\88\88\88\88\88\88\88wwwp\00\00\00\00\00\00\00\00\00\00\00\00\00\00\88\88\88\88\88\88\88\88\80\00\08\88\88\00\00\00\80\00\00\00\00\00\00\00\00\00\08\88\88\80\00\08\88\88\88\88\88\88\88\88\88\88\88\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\08\88\88\88\88\88\88\88\88\88\88\88\00\00\88\88\88\00\00\00\00\00\00\00\00\00\00\80\00\00\08\88\88\00\00\88\88\88\88\88\88\88\88\80\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\08\88\88\88\88\88\88\88\88\80\00\88\88\88\88\00\00\00\00\00\00\00\00\00\00\00\00\08\88\88\00\00\00\88\88\88\88\88\88\88\88\80\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\08\88\88\88\88\88\88\88\80\00\08\88\88\88\88\88\88\00\00\00\00\00\00\00\00\00\00\08\88\00\00\00\00\88\88\88\88\88\88\88\88\88\88\88\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\88\88\88\88\88\88\88\80\08\88\88\88\88\88\88\88\80\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\08\88\88\88\88\88\88\88\88\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\88\88\88\88\88\88\88\88\88\88\88\88\88\88\80\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\08\88\88\88\88\88\88\88\88\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\88\88\88\88\88\88\88\88\00\88\88\88\88\88\88\88\80\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\08\88\88\88\88\88\88\88\88\88\88\80\00\00\00\08\88\00\00\00\00\00\00\00\00\00\00\08\88\88\88\88\88\88\00\00\88\88\88\88\88\88\88\88\80\00\00\00\00\00\00\00\08\88\87wwwwww\88\88\88\88\88\88\88\88\88\88\87w\88\88\88\88wwwwwwwwwww\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88wwwp\00\00\00\08\80\00\00\00\00\00\00\00\08\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\80\00\00\00\00\00\00\00\00\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\00\00\00\00\00\00\00\00\00\00\00\00\00\00\08\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\80\00\00\00\00\00\00\00\00\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\00\00\00\00\00\00\00\00\88\00\00\00\00\00\00\00\08\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\80\00\00\00\00\00\00\00\00\00\00\08\88\88\88\80\00\88\88\88\88\88\88\88\88\88\88\80\00\00\00\00\00\00\88\88\00\00\00\00\00\00\00\00\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\00\00\00\00\00\00\00\00\08\88\88\80\00\00\88\88\88\88\88\88\88\88\88\88\88\88\80\00\00\00\08\88\00\00\00\00\00\00\00\00\00\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\00\00\00\00\00\00\00\00\08\88\80\00\00\88\88\88\08\88\88\88\88\88\88\88\88\88\80\00\00\08\88\80\00\00\00\00\00\00\00\00\00\00\00\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\80\00\00\00\00\00\00\00\00\00\00\00\88\88\00\00\00\88\88\88\88\88\88\88\88\88\88\08\88\88\80\00\00\88\88\00\00\00\00\00\00\00\00\08\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\80\00\00\00\00\00\00\00\00\08\88\00\00\00\00\88\88\88\88\88\88\88\88\88\88\88\88\80\00\00\88\88\88\00\00\00\00\00\00\00\00\08\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\00\00\00\00\00\00\00\88\88\88wwx\88\88\88\88\88\8A\AA\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88wwwww\88\88\88\88\8A\AA\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\87ww\00\08\88\88\80\00\08\88\80\00\00\88\88\8A\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\00\00\00\00\00\00\00\08\88\AA\A8\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\80\00\00\00\88\88\80\00\88\88\80\00\00\00\88\88\88\88\88\AA\A8\88\88\88\88\88\88\88\88\88\88\88\88\00\00\00\00\00\00\00\08\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\80\00\00\88\88\00\00\88\88\88\00\00\00\00\88\88\88\88\8A\AA\A8\88\88\88\88\88\88\88\88\88\88\88\88\88\88\80\00\00\00\00\08\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\00\00\08\88\88\80\00\00\00\00\00\00\08\88\AA\AA\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\80\00\00\00\00\00\00\00\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\80\00\08\88\88\88\00\00\00\00\00\00\00\08\88\88\88\88\8A\AA\88\88\88\88\88\88\88\88\88\88\88\88\80\00\00\00\00\00\00\08\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\80\88\88\88\88\88\88\88\88\00\00\00\00\08\88\88\88\88\AA\AA\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\00\00\00\00\08\88\88\88\88\88\88\88\80\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\00\00\00\00\00\00\00\88\8A\AA\A8\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\00\00\00\00\00\00\00\08\88\88\88\00\00\88\88\88\88\88\88\AA\88\88\88\88\88\88\88\88\88\88\88\88\80\00\00\00\00\00\00\00\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\00\88\88\80\00\88\88\88\88\88\88\88\88\88\88\88\8A\AA\AA\AA\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88wwwx\88\88\88\8A\AA\AA\A8\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\87wx\88\88\88\88\88\88\88\88\88\88\88\8A\AA\AA\A8\8A\AA\88\88\88\88\88\88\88\88\88\88\88\88\80\00\00\00\00\00\08\88\8A\AA\AA\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\00\00\88\88\88\88\88\88\88\88\80\00\08\88\88\88\88\AA\AA\AA\A8\88\88\88\88\88\88\88\88\88\88\88\88\00\00\00\00\00\00\88\8A\AA\88\88\88\AA\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\00\00\88\88\88\88\8A\AA\AA\AA\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\00\00\00\08\88\88\88\88\8A\AA\A8\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\80\00\88\88\80\08\88\8A\AA\AA\AA\A8\88\88\88\88\88\88\88\88\88\88\88\88\88\88\00\00\00\08\88\88\88\88\AA\AA\88\88\88\88\88\88\88\88\8A\AA\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\00\00\00\88\88\AA\AA\AA\AA\AA\A8\88\88\88\88\88\88\88\88\88\88\88\88\80\00\00\00\00\00\88\88\88\88\88\88\88\88\88\88\88\8A\AA\AA\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\80\00\00\00\88\88\88\88\AA\AA\AA\A8\88\88\88\88\88\88\88\88\88\88\88\88\88\88\80\00\00\00\88\88\88\88\88\88\88\88\88\88\88\8A\AA\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\80\00\00\00\00\00\88\88\AA\AA\AA\A8\88\88\88\88\88\88\88\88\88\88\88\88\88\88\80\00\00\08\88\88\88\88\88\88\88\88\88\88\88\88\88\88\AA\AA\AA\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\00\00\00\08\88\AA\AA\AA\AA\AA\AA\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\8A\88\88\88\88\88\88\88\88\AA\AA\AA\AA\A8\88\88\88\88\88\88\88\88\88\88\88\88\88\88\80\00\08\88\88\88\8A\AA\AA\AA\AA\A8\88\88\88\88\88\88\88\8A\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\8A\AA\AA\AA\AA\AA\AA\AA\88\88\88\88\88\88\88\88\88\88\88\88\80\00\88\88\88\88\88\AA\AA\AA\AA\A8\AA\AA\A8\88\88\88\AA\AA\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\8A\AA\AA\AA\AA\AA\AA\AA\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\80\00\88\88\AA\AA\AA\AA\AA\AA\AA\88\88\88\AA\AA\A8\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\AA\AA\AA\AA\AA\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\00\00\88\88\88\88\8A\AA\AA\AA\A8\88\88\8A\AA\AA\88\8A\AA\AA\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\AA\AA\AA\AA\AA\AA\AA\88\88\88\88\88\88\88\88\88\88\88\88\80\00\08\88\88\88\88\8A\AA\AA\AA\88\88\8A\AA\88\88\8A\AA\AA\AA\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\00\88\88\AA\AA\AA\AA\AA\AA\AA\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\8A\AA\AA\88\88\AA\AA\88\88\88\AA\AA\AA\AA\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\80\00\88\88\88\88\AA\AA\AA\AA\AA\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\80\00\88\88\88\88\88\88\AA\AA\88\88\88\8A\AA\AA\AA\AA\AA\AA\A8\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\8A\AA\AA\AA\AA\AA\AA\A8\88\88\88\88\88\88\88\88\88\88\88\88\80\08\88\88\88\88\88\8A\AA\A8\88\88\88\AA\AA\AA\AA\AA\AA\AA\A8\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\00\00\88\8A\AA\AA\AA\AA\AA\AA\A8\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\8A\AA\AA\A8\88\8A\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\A8\88\AA\AA\AA\88\88\88\88\88\88\88\88\88\8A\A8\88\88\8A\AA\AA\88\88\AA\AA\AA\AA\AA\AA\AA\AA\A8\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\8A\AA\AA\AA\AA\AA\AA\AA\AA\A8\88\AA\AA\AA\AA\88\88\88\88\88\88\88\88\88\88\88\88\88\AA\A8\88\88\88\AA\AA\AA\AA\AA\AA\AA\AA\A8\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\8A\AA\AA\AA\AA\AA\AA\AA\A8\88\8A\AA\AA\AA\AA\AA\AA\88\88\88\88\88\88\88\88\88\88\8A\A8\88\88\88\8A\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\A8\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\8A\AA\AA\AA\AA\AA\AA\AA\88\8A\AA\AA\AA\AA\AA\AA\AA\A8\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\8A\AA\AA\AA\AA\AA\AA\AA\AA\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\A8\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\8A\AA\AA\AA\AA\AA\AA\AA\AA\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\AA\AA\AA\AA\AA\AA\AA\AA\A8\AA\AA\AA\AA\AA\AA\AA\A8\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\8A\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\A8\88\88\88\8A\AA\88\88\88\88\88\88\88\88\88\88\AA\AA\AA\AA\AA\AA\AA\88\8A\AA\AA\AA\AA\AA\AA\AA\AA\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\AA\AA\AA\AA\AA\AA\AA\AA\A8\88\88\8A\AA\AA\88\88\88\88\88\88\88\88\88\88\88\88\8A\AA\AA\AA\88\88\AA\AA\AA\AA\AA\AA\AA\AA\AA\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\88\AA\AA\AA\AA\AA\AA\AA\AA\88\88\8A\AA\AA\88\88\88\88\88\88\88\88\88\88\88\88\88\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\88\88\88\88\88\88\88\88\88\88\88\88\88\88\8A\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\A8\88\88\88\88\88\88\88\88\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\88\88\88\88\88\88\88\88\8A\88\88\88\88\88\88\88\8A\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\A8\88\88\88\88\88\88\88\88\88\88\8A\AA\AA\AA\A8\88\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\88\88\88\88\88\88\88\AA\A8\88\88\88\88\88\88\88\88\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\88\88\88\88\88\88\88\88\8A\AA\AA\A8\88\88\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\A8\88\88\88\AA\AA\88\88\88\88\88\88\88\88\88\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\88\88\88\88\88\88\88\88\AA\AA\A8\88\88\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\A8\88\88\8A\AA\A8\88\88\88\88\88\88\88\88\88\88\88\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\88\88\88\88\88\88\88\88\88\88\88\88\8A\AA\88\88\88\AA\AA\AA\AA\AA\AA\AA\AA\AA\A8\8A\AA\AA\A8\88\88\AA\AA\88\88\88\88\88\88\88\88\8A\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\A8\88\88\88\88\88\88\88\88\8A\AA\88\88\88\88\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\88\8A\AA\AA\AA\88\88\88\88\88\88\88\88\8A\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\A8\88\88\88\88\88\88\88\8A\AA\A8\88\88\88\88\88\88\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\A8\8A\AA\AA\AA\A8\88\88\88\88\88\88\88\88\88\88\8A\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\A8\88\88\88\88\88\88\88\AA\A8\88\88\88\88\88\88\88\8A\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\A8\88\88\88\88\88\88\88\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\A8\88\88\88\AA\AA\A8\88\AA\AA\A8\88\88\88\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\88\88\88\88\88\88\88\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\A8\88\88\AA\AA\88\88\AA\AA\AA\88\88\88\88\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\88\88\88\88\88\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\88\88\AA\AA\AA\A8\88\88\88\88\88\88\8A\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\A8\88\88\88\88\88\88\8A\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\A8\88\8A\AA\AA\AA\88\88\88\88\88\88\88\8A\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\A8\88\88\88\88\88\88\8A\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\A8\AA\AA\AA\AA\AA\AA\AA\AA\88\88\88\88\8A\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\A8\88\88\88\88\8A\AA\AA\AA\AA\AA\AA\AA\A8\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\A8\88\88\88\88\88\88\88\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\88\88\88\88\8A\88\88\8A\AA\AA\AA\88\88\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\A8\88\88\88\88\88\88\88\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\88\88\88\88\88\88\88\AA\AA\AA\88\88\8A\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\88\88\88\88\88\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\A8\88\88\88\8A\AA\AA\A8\88\88\AA\A8\88\88\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\A8\88\88\88\8A\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\88\88\AA\AA\AA\AA\AA\AA\AA\AA\A8\88\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\88\88\88\88\88\8A\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\A8\88\88\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\88\88\88\8A\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\A8\88\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\88\88\88\8A\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\88\88\88\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\88\88\88\88\88\88\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\A8\88\88\88\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\A8\88\88\8A\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\A8\88\88\8A\A8\88\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\A8\88\88\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\88\88\88\8A\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\A8\88\AA\AA\AA\88\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\A8\88\88\88\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\A8\88\8A\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\88\88\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\A8\88\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\88\88\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\A8\88\8A\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\88\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\A8\88\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\A8\88\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\A8\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\88\8A\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\88\8A\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\A8\88\8A\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA\AA", align 1
@_ZN5rallyL14SceneryPaletteE = internal constant [16 x i8] c"\F4\F5\F9\FA\FF\EA\E5\E4\D4\C4\C5\D9\FC\D5\D8\DA", align 1
@__const._ZN12_GLOBAL__N_18loadFontEv.consolidate = private unnamed_addr constant [6 x i8] c"\17\00\A0\C5\F9\0E", align 1
@_ZN5rally4gameL10FontPixelsE = internal constant <{ [983 x i8], [1065 x i8] }> <{ [983 x i8] c"\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\10\10\10\10\10\00\10\00((\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00dh\08\10 ,L\00\00\00\00\00\00\00\00\00\10\10 \00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\10\10|\10\10\00\00\00\00\00\00\00\00\00\00\00\00\00|\00\00\00\00\00\00\00\00\00\18\18\00\04\08\08\10  @\008DLTdD8\00\100\10\10\10\108\008D\04\08\10 |\00x\04\048\04\04x\00\08\18(H|\08\08\00|@@x\04\04x\008@@xDD8\00|\04\08\08\10\10\10\008DD8DD8\008DD<\04\048\00\00\10\10\00\10\10\00\00\00\00\00\00\00\00\00\00\08\10 @ \10\08\00\00|\00|\00\00\00\00 \10\08\04\08\10 \008D\04\08\10\00\10\00\00\00\00\00\00\00\00\008DD|DDD\00xDDxDDx\00<@@@@@<\00xDDDDDx\00|@@x@@|\00|@@x@@@\00<@@\\DD<\00DDD|DDD\00|\10\10\10\10\10|\00\1C\08\08\08HH0\00DHP`PHD\00@@@@@@|\00DlTTDDD\00DddTLLD\008DDDDD8\00xDDx@@@\008DDDTH4\00xDDxPHD\00<@@8\04\04x\00|\10\10\10\10\10\10\00DDDDDD8\00DDDDD(\10\00DDDTTlD\00DD(\10(DD\00DD(\10\10\10\10\00|\04\08\10 @|\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\008DD|DDD\00xDDxDDx\00<@@@@@<\00xDDDDDx\00|@@x@@|\00|@@x@@@\00<@@\\DD<\00DDD|DDD\00|\10\10\10\10\10|\00\1C\08\08\08HH0\00DHP`PHD\00@@@@@@|\00DlTTDDD\00DddTLLD\008DDDDD8\00xDDx@@@\008DDDTH4\00xDDxPHD\00<@@8\04\04x\00|\10\10\10\10\10\10\00DDDDDD8\00DDDDD(\10\00DDDTTlD\00DD(\10(DD\00DD(\10\10\10\10\00|\04\08\10 @|", [1065 x i8] zeroinitializer }>, align 1
@_ZN5rally4gameL11SignArtworkE = internal constant <{ { <{ i8, i8, i8, i8, i8, i8, i8, [9 x i8] }>, [2048 x i8] }, { <{ i8, i8, i8, i8, i8, i8, [10 x i8] }>, [2048 x i8] }, { <{ i8, i8, i8, i8, i8, i8, [10 x i8] }>, [2048 x i8] }, { <{ [8 x i8], [8 x i8] }>, [2048 x i8] }, %"struct.rally::game::SignArt", { <{ i8, i8, i8, i8, i8, i8, [10 x i8] }>, [2048 x i8] }, { <{ i8, i8, i8, i8, i8, [11 x i8] }>, [2048 x i8] }, { <{ i8, i8, i8, i8, i8, [11 x i8] }>, [2048 x i8] } }> <{ { <{ i8, i8, i8, i8, i8, i8, i8, [9 x i8] }>, [2048 x i8] } { <{ i8, i8, i8, i8, i8, i8, i8, [9 x i8] }> <{ i8 0, i8 -1, i8 -48, i8 -4, i8 -37, i8 -3, i8 -22, [9 x i8] zeroinitializer }>, [2048 x i8] c"\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11#3\22#323322\2222\222#3\2233\22#3\2233\22#32\11\112\2222\22\22\222\223\2222\2222\2222\2222\2222\2222\22\22\11\112\2222\22\22\222\223\2222\2222\2222\2222\2222\2222\22\22\11\11332232\222\222222\2223322\2222\22233\22#3\22\11\112\2222\222\222\222#22\2222\2222\2222\22222\22\22\222\11\112\2222\222\222\222#2##\222\2222\2222\2222#\22\22\222\11\112\222#323322\222\222\222\22233\22#3\222\22233\22\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22$DB\22\22\22\22\22\22\22\22\22U\22\22\22\22\22U\22\22\22\22\22\11\11\22\22\22\22\22\22$DB\22\22\22\22\22\22\22\22\22U\22\22\22\22\22U\22\22\22\22\22\11\11\22\22\22\22\22$DDDB\22\22\22\22\22\22\22\22\22U\22\22\22U\22\22\22\22\22\22\11\11\22\22\22\22\22$DDDB\22\22\22\22\22\22\22\22\22U\22\22\22U\22\22\22\22\22\22\11\11\22\22\22\22$DDDDDB\22\22\22\22\22\22\22UUUUUUU\22\22\22\22\22\11\11\22\22\22\22$DDDDDB\22\22\22\22\22\22\22UUUUUUU\22\22\22\22\22\11\11\22\22\22$DB$DB$DB\22\22\22\22\22UU\22UUU\22UU\22\22\22\22\11\11\22\22\22$DB$DB$DB\22\22\22\22\22UU\22UUU\22UU\22\22\22\22\11\11\22\22\22$DDDDDDDB\22\22\22\22UUUUUUUUUUU\22\22\22\11\11\22\22\22$DDDDDDDB\22\22\22\22UUUUUUUUUUU\22\22\22\11\11\22\22\22\22\22$B\22$B\22\22\22\22\22\22U\22UUUUUUU\22U\22\22\22\11\11\22\22\22\22\22$B\22$B\22\22\22\22\22\22U\22UUUUUUU\22U\22\22\22\11\11\22\22\22\22$B$DB$B\22\22\22\22\22U\22U\22\22\22\22\22U\22U\22\22\22\11\11\22\22\22\22$B$DB$B\22\22\22\22\22U\22U\22\22\22\22\22U\22U\22\22\22\11\11\22\22\22$B$B\22$B$B\22\22\22\22\22\22\22UU\22UU\22\22\22\22\22\22\11\11\22\22\22$B$B\22$B$B\22\22\22\22\22\22\22UU\22UU\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\00\00\00\00\00ff\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00ff\00\00\00\00\00\00\00\00\00\00ff\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00ff\00\00\00\00\00\00\00\00\00\00ff\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00ff\00\00\00\00\00\00\00\00\00\00ff\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00ff\00\00\00\00\00\00\00\00\00\00ff\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00ff\00\00\00\00\00\00\00\00\00\00ff\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00ff\00\00\00\00\00\00\00\00\00\00ff\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00ff\00\00\00\00\00\00\00\00\00\00ff\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00ff\00\00\00\00\00\00\00\00\00\00ff\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00ff\00\00\00\00\00\00\00\00\00\00ff\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00ff\00\00\00\00\00\00\00\00\00\00ff\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00ff\00\00\00\00\00\00\00\00\00\00ff\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00ff\00\00\00\00\00\00\00\00\00\00ff\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00ff\00\00\00\00\00\00\00\00\00\00ff\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00ff\00\00\00\00\00\00\00\00\00\00ff\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00ff\00\00\00\00\00\00\00\00\00\00ff\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00ff\00\00\00\00\00" }, { <{ i8, i8, i8, i8, i8, i8, [10 x i8] }>, [2048 x i8] } { <{ i8, i8, i8, i8, i8, i8, [10 x i8] }> <{ i8 0, i8 -1, i8 -64, i8 -3, i8 -4, i8 -22, [10 x i8] zeroinitializer }>, [2048 x i8] c"\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\2233\223323323322\22233\2233233\22\22\22\22\11\11\22\22\222\2222\22\222\22\222\22\223\2222\2222\22\222\222\22\22\22\11\11\22\22\222\2222\22\222\22\222\22\223\2222\2222\22\222\222\22\22\22\11\11\22\22\222\22233\2233\2233\222222\22233\2233\22\22\22\22\11\11\22\22\222\2222\22\222\22\222\22\222#22\2222\22\2222\22\22\22\22\11\11\22\22\222\2222\22\222\22\222\22\222#22\2222\22\222#\22\22\22\22\11\11\22\22\2233\223322\22\223322\22233\223322\222\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22DDB\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22DDB\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22DD\11\14DD\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22DD\11\14DD\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22DD\11\14DD\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22$DD\11\11\11\11\11\11D\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22$DD\11\11\11\11\11\11D\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22DDDDD\11\11\11\11\11\11\11\11\11\14DDDD\22\22\22\22\22\22\22\22\11\11\22\22\22DDDDD\11\11\11\11\11\11\11\11\11\14DDDD\22\22\22\22\22\22\22\22\11\11\22\22\22DDDDD\11\11\11\11\11\11\11\11\11\14DDDD\22\22\22\22\22\22\22\22\11\11\22\22\22\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\22\22\22\11\11\22\22\22\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\22\22\22\11\11\22\22\22DDDDD\11\11\11\11\11\11\11\11\11\14DDDD\22\22\22\22\22\22\22\22\11\11\22\22\22DDDDD\11\11\11\11\11\11\11\11\11\14DDDD\22\22\22\22\22\22\22\22\11\11\22\22\22DDDDD\11\11\11\11\11\11\11\11\11\14DDDD\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22$DD\11\11\11\11\11\11D\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22$DD\11\11\11\11\11\11D\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22DD\11\14DD\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22DD\11\14DD\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22DD\11\14DD\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22DDB\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22DDB\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00" }, { <{ i8, i8, i8, i8, i8, i8, [10 x i8] }>, [2048 x i8] } { <{ i8, i8, i8, i8, i8, i8, [10 x i8] }> <{ i8 0, i8 -1, i8 -64, i8 -13, i8 -47, i8 -22, [10 x i8] zeroinitializer }>, [2048 x i8] c"\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22!\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22!!\12\133#4B\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\22!#\132\13C2#333\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22#33!3333C\22#\134#3C3B\22\22\22\22\22\22\11\11\22\22\22\22\221C3##B13#C2#$B\22B\22\22DDD\22\22\22\22\11\11\22\22\22\22\22\1343323$B\22\22\22$DDBDB\22A34D\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22DDDDDA\133\14C4\22334D\22\22\22\11\11\22\22\22\22\22\22\22\22DB$DA\113\14C334C4BCDDD\22\22\22\11\11\22\22$DDA\11BCD$3C333C4D3C4BCDDD\22\22\22\11\11\22\22\22C333\14CDD3C4D3C4D3C4B\1334B\22\22\22\11\11\22\22\22$3DC4CDD3C4D3C4D4C4B34DD\22\22\22\11\11\22\22\22$3DC4CDD3C4A4C\11\134C4B3DDD!2\22\11\11\22\22\22$3DC4CDD3C\11\134C33DC4D3DDD\133\22\11\11\22\22\22$3DC4CDD3C33DC4DDC1\11334D$4\22\11\11\22!B$3\113DCDD3C43DC4DDC3333DD\22B\22\11\11\22#2$334DC4D4C4C4C4D\22DDDDDDA\14\22\22\11\11#33D3DDD#334CDDDDDB\22$D\11D\13334B\22\11\11\22#\22$3DDD$33DDDDDDDD\22!33D3334B\22\11\11\22!B$3DD\22\22DDDDA\11\13\14C4B#33C4DC4B\22\11\11\22B\22$3DB\22DA\1131C333C4B#4DC4DDDB\22\11\11\22D\22$3A4\22CC333C4D3C4B#1\11C3\131DB\22\11\11\22D\22$3C4BCC4D3C4D3C4B#33D333DB\22\11\11\22CB$3C4BCC4DCC4D3C4B#4DDDD3D\22\22\11\11\22C4$3C4BCC4D\13C4A3C4B#4DDDD3D\22\22\11\11\22C1D3C4BCC1\134C334C4DC4AA\1133D\22\22\11\11\22C3\143C4BCC33DC4DDC1\13333C33DD\22\22\11\11\22C313C4BCC334C4DDC33334DDDDD\22\22\11\11\22C333C4DCC4C4C4DD$DDDDDDDDDB\22\22\11\11\22C433D333C4D3DDD\22$DDDDDB\22\22\22\22\22\22\11\11\22C4C3DC3DDDDDDDD\22\22\22\22\22\22!33332\22\22\11\11\22C4D3D$DDBDD$\22\22\22\22!333333DDB\22\22\22\11\11\22CDBCD$DD\22\22\22\22\22!333334DDB\22\22\22\22\22\22\11\11\22$DBDD\22\22\22!333334DDB\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22DB$D\22#334DDB\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22$\22\22$B\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\22!3334B\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22#333DD\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22$\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00" }, { <{ [8 x i8], [8 x i8] }>, [2048 x i8] } { <{ [8 x i8], [8 x i8] }> <{ [8 x i8] c"\00\FF\D0\DF\E0\EA\E5\FA", [8 x i8] zeroinitializer }>, [2048 x i8] c"\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22#3\22#32#3\222\222\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\222\2222\22\222\2223\222\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\222\2222\22\222\2223\222\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\223322322\222222\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\222\2222\2222\2222#2\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\222\2222\2222\2222#2\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\222\222#32#3\222\222\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22DDD\11TDDB\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22DDD\11\14DDB\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22DDD\11\14DDB\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22DDD\11\14DDB\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22DDD\11dDDB\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22DDD\11dDDB\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22DA\15aA\11DB\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22DQ\11EA\11DB\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22D\11\11\14\11\11\14B\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22A\11\11D\14A\14B\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22A\11\11D\14A\11B\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22A\11\14\11\11\11\11B\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22a\14\14\11\11\14\11B\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\11T\14\11\11Dqb\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22qDF\11dDaR\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22qE\15DA\14ab\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\11Q\17a\16\11\11B\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22Q\11\14\11\14\11\11R\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22A\11\14\11\14\11\11B\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\11\11e\16\14\11\11\12\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\11\11FDGq\11\12\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22a\11DDDG\11\12\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22#3#\22##\22##33#32\2232#\22#\22\22\22\22\22\11\11\22\22\22\22\22\222#\22##\222#\22\22#\22##\22##\22#\22\22\22\22\22\11\11\22\22\22\22\22\222#\22###\22#\22\22#\22##\22#\2222\22\22\22\22\22\11\11\22\22\22\22\22\222#\22##2\22#32#32#\22#\22#\22\22\22\22\22\22\11\11\22\22\22\22#\222#\22###\22#\22\22#\22##\22#\2222\22\22\22\22\22\11\11\22\22\22\22#\222#\22##\222#\22\22#\22##\22##\22#\22\22\22\22\22\11\11\22\22\22\22\223\22\2232#\22##33#32\2232#\22#\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00" }, %"struct.rally::game::SignArt" { [16 x i8] c"\00\FF\C0\C2\D2\D6\D5\C1\C6\EF\EA\D4\D7\D0\EB\C5", [2048 x i8] c"\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22!\11\11\12\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\22\11\22\22\22\22\11\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\12#334E2!&\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\12#32\22#$UB\11\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22!#33\22\12\22$EU2\12\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\12333\22!\22tTUU!\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22!#333\22!\22$DEE\82\12\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\123334\22a\92\22DT4D\A2\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\13333\22\12\22\22\11*\11#3!\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22!#333\22\22\22\22\22!\11\12#2b\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22!3332\12\22\22\22\22\A2\22\11\A22\12\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\12333\22\22\22\22\22\22\22\22\22\1A4\12\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\12334\22\22\22\22\22\22!\22\22\113!\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\133#2\22\22\12\22\22\12!\22\11\11S!\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22+#2\11\22*!\12\22\22\11!!!\123q\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22#:!#!!\12\22\22\11!!\11\123\C1\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22#6\12\125\22\22\22\22\22\11\11\11#3A\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22#2\11\11\22\22\22\22\22\22!\11\12331\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22#2\1A\11\11!\12\22\22\22\12\12#33!\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\132\11\12\11\11\11\11a\11\12'333!R\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\123\22\22!\11!\11\22\11\123333\222\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\1232\11\11\11!\11\11a\123333\122\22\22\22\22\22\22\11\11\22\22\22\22\22\22-!33\22\16\22\1A\11!\11\22\22#32\12r\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22!#3r\22!\22\19\1A\12!\11\1231#b\22\22\22\22\22\22\11\11\22\22\22\22\22\22+\B2\142!\11\11\12\22\22!\11\11\11s)#\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\12!\11\11\11\11\12\22\11\11a\112\12#\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\11\11\11\16\11\22\12!\22\11\12!\222\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\12\11\22b\22\11\12\12!\11\22\12\222\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22!\11!\12#3\22\22\22\11!!\22\222\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22*\12!'\22\22\22\22\22\22f\22\22'\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\E1\22\22\22\22\22\22\A2\22\22#\F2\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\22*\AA\22&\AA\A2\22\22\22#\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22%\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\CC\CC\C2\C2\22\C2\CC\CC\C2\CC\CC\C2\C2\22\C2\CC\CC\22\CC\CC\C2\CC\CC\22\22\22\22\11\11\22\22\22\C2\22\22\C2\22\C2\22\C2\22\C2\22\22\CC\22\C2\C2\22\C2\C2\22\22\C2\22\C2\22\22\22\11\11\22\22\22\C2\22\22,,\22\22\C2\22\C2\22\22\CC\22\C2\C2\22\C2\C2\22\22\C2\22\C2\22\22\22\11\11\22\22\22\CC\CC\22\22\C2\22\22\C2\22\CC\CC\22\C2\C2\C2\C2\22\C2\CC\CC\22\CC\CC\22\22\22\22\11\11\22\22\22\C2\22\22,,\22\22\C2\22\C2\22\22\C2,\C2\C2\22\C2\C2\22\22\C2\C2\22\22\22\22\11\11\22\22\22\C2\22\22\C2\22\C2\22\C2\22\C2\22\22\C2,\C2\C2\22\C2\C2\22\22\C2,\22\22\22\22\11\11\22\22\22\CC\CC\C2\C2\22\C2\22\C2\22\CC\CC\C2\C2\22\C2\CC\CC\22\CC\CC\C2\C2\22\C2\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\00\00\00\00\00\AA\AA\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\AA\AA\00\00\00\00\00\00\00\00\00\00\AA\AA\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\AA\AA\00\00\00\00\00\00\00\00\00\00\AA\AA\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\AA\AA\00\00\00\00\00\00\00\00\00\00\AA\AA\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\AA\AA\00\00\00\00\00\00\00\00\00\00\AA\AA\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\AA\AA\00\00\00\00\00\00\00\00\00\00\AA\AA\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\AA\AA\00\00\00\00\00\00\00\00\00\00\AA\AA\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\AA\AA\00\00\00\00\00\00\00\00\00\00\AA\AA\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\AA\AA\00\00\00\00\00\00\00\00\00\00\AA\AA\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\AA\AA\00\00\00\00\00\00\00\00\00\00\AA\AA\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\AA\AA\00\00\00\00\00\00\00\00\00\00\AA\AA\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\AA\AA\00\00\00\00\00\00\00\00\00\00\AA\AA\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\AA\AA\00\00\00\00\00\00\00\00\00\00\AA\AA\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\AA\AA\00\00\00\00\00\00\00\00\00\00\AA\AA\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\AA\AA\00\00\00\00\00\00\00\00\00\00\AA\AA\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\AA\AA\00\00\00\00\00\00\00\00\00\00\AA\AA\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\AA\AA\00\00\00\00\00" }, { <{ i8, i8, i8, i8, i8, i8, [10 x i8] }>, [2048 x i8] } { <{ i8, i8, i8, i8, i8, i8, [10 x i8] }> <{ i8 0, i8 -1, i8 -32, i8 -27, i8 -6, i8 -22, [10 x i8] zeroinitializer }>, [2048 x i8] c"\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\12\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22!\11\13\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22!\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22!\11\14\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22!\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22#\11\12\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\12\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\12\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\221B\11\12\14\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22!\11\12\11\22\11\11\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22Q\11\13%!\11\11\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\11\11\11\22!\11\11\12\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22%\11\11\11\22\11\11\11\12\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22!\11\11\11\22!\11\11\11\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\221\11\11\12Q!\11\11\11\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\11\11\11\12\11\11\11!\112\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\11\14\11\22\11\11\11!\11\12\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\11\12\11!\11\11\11#\11\12\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\11\12\11!\11\11\11\22\11\12\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\112#!\11\11\12\22A\12\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\11\22\22!\11R\22\221\12\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\112!\22\22\22\1121\12\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22#\112\11\12#\12\11\12\11\12\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22$\11A\11\12\11\15A\11\11\12\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22$\11\11\11\22\11\11!\11\11\14\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22!\11\11$\11\11!\11\11\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\11\11\14!\11\11!\11\11\12\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22!\11\11\12!\13\11%\11\11\11\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22!\11\11\12\12\22!\22\11\11\11\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22$\11\11R\22\22\22\22\11\11\11\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\11E\22\22\22\22\22#A\12\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22!\11\22!\11\12!\11\22\12\22\12\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\12\22\12\12\22\22\12\22\12\11\22\12\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\12\22\12\12\22\22\12\22\12\11\22\12\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\11\11\12\12\11\12\12\22\12\12\12\12\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\12\22\12\12\22\12\12\22\12\12!\12\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\12\22\12\12\22\12\12\22\12\12!\12\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\12\22\12!\11\12!\11\22\12\22\12\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00UU\00\00\00\00\00" }, { <{ i8, i8, i8, i8, i8, [11 x i8] }>, [2048 x i8] } { <{ i8, i8, i8, i8, i8, [11 x i8] }> <{ i8 0, i8 -1, i8 -63, i8 -33, i8 -22, [11 x i8] zeroinitializer }>, [2048 x i8] c"\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22!\11\12!\11\11\22\11\11!\22!\22\11\12!\11\12!\11\12\22\22\22\22\22\11\11\22\22\22\22!\22!\22!\22!\22\22!\22!!\22!!\22!!\22!\22\22\22\22\22\11\11\22\22\22\22!\22!\22!\22!\22\22!\22!!\22!!\22!!\22!\22\22\22\22\22\11\11\22\22\22\22!\11\12\22!\22!\22\22!\11\11!\11\11!\11\12!\22!\22\22\22\22\22\11\11\22\22\22\22!!\22\22!\22!\22\22!\22!!\22!!!\22!\22!\22\22\22\22\22\11\11\22\22\22\22!\22\12\22!\22!\22\22!\22!!\22!!\22\12!\22!\22\22\22\22\22\11\11\22\22\22\22!\22!!\11\11\22\11\11!\22!!\22!!\22!!\11\12\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22!\11\11!\22!!\11\12!\22!!\22!!\11\11!\11\12\22\11\11!\11\11\22\22\11\11\22\22!\22!\22!!\22!!\12!!\12!\22!\22!\22!!\22\22!\22\22\22\22\11\11\22\22!\22!\22!!\22!!\12!!\12!\22!\22!\22!!\22\22!\22\22\22\22\11\11\22\22!\22!\22!!\11\12!!!!!!\22!\22!\22!!!\11!\11\12\22\22\11\11\22\22!\22!\22!!!\22!\22\11!\22\11\22!\22!\22!!\22!!\22\22\22\22\11\11\22\22!\22!\22!!\22\12!\22\11!\22\11\22!\22!\22!!\22!!\22\22\22\22\11\11\22\22!\22\22\11\12!\22!!\22!!\22!!\11\11!\11\12\22\11\11!\11\11\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22#32332#3\2233\22#322\22233233\22\22\22\22\11\11\22\22\222\22\22\222\222\2222\2222\22\222\222\222\222\222\22\22\22\11\11\22\22\222\22\22\222\222\2222\2222\22\222\222\222\222\222\22\22\22\11\11\22\22\22#3\22\222\2233233\22#3\22332\222\2233\22\22\22\22\11\11\22\22\22\22\222\222\222\22222\22\22\2222\222\222\222\22\22\22\22\22\11\11\22\22\22\22\222\222\222\2222#\22\22\2222\222\222\222\22\22\22\22\22\11\11\22\22\2233\22\222\222\2222\22233\222\2223322\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22#323322\2223323322\2223322\22\22\22\22\22\11\11\22\22\222\22\222\22\223\222\222\22\222\223\2222\22\222\22\22\22\22\22\11\11\22\22\222\22\222\22\223\222\222\22\222\223\2222\22\222\22\22\22\22\22\11\11\22\22\22#3\2233\22222\222\22\222\2222233\222\22\22\22\22\22\11\11\22\22\22\22\2222\22\222#2\222\22\222\222#22\22\222\22\22\22\22\22\11\11\22\22\22\22\2222\22\222#2\222\22\222\222#22\22\222\22\22\22\22\22\11\11\22\22\2233\223322\222\222\223322\222332332\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\00\00\00\00\00DD\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00DD\00\00\00\00\00\00\00\00\00\00DD\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00DD\00\00\00\00\00\00\00\00\00\00DD\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00DD\00\00\00\00\00\00\00\00\00\00DD\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00DD\00\00\00\00\00\00\00\00\00\00DD\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00DD\00\00\00\00\00\00\00\00\00\00DD\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00DD\00\00\00\00\00\00\00\00\00\00DD\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00DD\00\00\00\00\00\00\00\00\00\00DD\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00DD\00\00\00\00\00\00\00\00\00\00DD\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00DD\00\00\00\00\00\00\00\00\00\00DD\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00DD\00\00\00\00\00\00\00\00\00\00DD\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00DD\00\00\00\00\00\00\00\00\00\00DD\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00DD\00\00\00\00\00\00\00\00\00\00DD\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00DD\00\00\00\00\00\00\00\00\00\00DD\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00DD\00\00\00\00\00\00\00\00\00\00DD\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00DD\00\00\00\00\00\00\00\00\00\00DD\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00DD\00\00\00\00\00" }, { <{ i8, i8, i8, i8, i8, [11 x i8] }>, [2048 x i8] } { <{ i8, i8, i8, i8, i8, [11 x i8] }> <{ i8 0, i8 -1, i8 -60, i8 -33, i8 -22, [11 x i8] zeroinitializer }>, [2048 x i8] c"\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\222\222332#3\222\222\222\22#32\22\22\22\22\22\22\11\11\22\22\22\22\22\222\222\222\222\2223\222\222\222\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22##\22\222\222\2223\222#\22\222\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\222\22\222\22332222\22\22\22#3\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22##\22\222\222\2222#2\22\22\22\22\222\22\22\22\22\22\22\11\11\22\22\22\22\22\222\222\222\222\2222#2\22\22\22\22\222\22\22\22\22\22\22\11\11\22\22\22\22\22\222\2223322\2222\222\22\22\2233\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22!\11\22!\11\12!\11\22\12\22\12\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\12\22\12\12\22\22\12\22\12\11\22\12\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\12\22\12\12\22\22\12\22\12\11\22\12\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\11\11\12\12\11\12\12\22\12\12\12\12\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\12\22\12\12\22\12\12\22\12\12!\12\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\12\22\12\12\22\12\12\22\12\12!\12\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\12\22\12!\11\12!\11\22\12\22\12\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\11\11\22\11\11\22!\11\22\22\11\12\11\11\12!\11\12\11\11\12!\11\12\22\22\22\11\11\22\22\22\12\22\12\12\22\12\12\22\12\22!\22\12\22\22\12\22\22\22\12\22\12\22\22\22\22\22\11\11\22\22\22\12\22\12\12\22\12\12\22\12\22!\22\12\22\22\12\22\22\22\12\22\12\22\22\22\22\22\11\11\22\22\22\11\11\22\11\11\22\12\22\12\22!\22\11\11\22\12\22\22\22\12\22!\11\22\22\22\22\11\11\22\22\22\12\22\22\12\12\22\12\22\12\12!\22\12\22\22\12\22\22\22\12\22\22\22\12\22\22\22\11\11\22\22\22\12\22\22\12!\22\12\22\12\12!\22\12\22\22\12\22\22\22\12\22\22\22\12\22\22\22\11\11\22\22\22\12\22\22\12\22\12!\11\22!\12\22\11\11\12!\11\12\22\12\22\11\11\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\22\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\11\00\00\00\00\00DD\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00DD\00\00\00\00\00\00\00\00\00\00DD\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00DD\00\00\00\00\00\00\00\00\00\00DD\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00DD\00\00\00\00\00\00\00\00\00\00DD\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00DD\00\00\00\00\00\00\00\00\00\00DD\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00DD\00\00\00\00\00\00\00\00\00\00DD\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00DD\00\00\00\00\00\00\00\00\00\00DD\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00DD\00\00\00\00\00\00\00\00\00\00DD\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00DD\00\00\00\00\00\00\00\00\00\00DD\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00DD\00\00\00\00\00\00\00\00\00\00DD\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00DD\00\00\00\00\00\00\00\00\00\00DD\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00DD\00\00\00\00\00\00\00\00\00\00DD\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00DD\00\00\00\00\00\00\00\00\00\00DD\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00DD\00\00\00\00\00\00\00\00\00\00DD\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00DD\00\00\00\00\00\00\00\00\00\00DD\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00DD\00\00\00\00\00\00\00\00\00\00DD\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00DD\00\00\00\00\00" } }>, align 1
@_ZN12_GLOBAL__N_15crashE = internal global %"struct.rally::game::Crash" zeroinitializer, align 1
@_ZN12_GLOBAL__N_115attractProgressE = internal unnamed_addr global i32 0, align 1
@_ZN5rally4gameL5RouteE = internal unnamed_addr constant [6 x %"struct.rally::game::RouteRecord"] [%"struct.rally::game::RouteRecord" { i16 60, i16 180, i16 0, i16 32 }, %"struct.rally::game::RouteRecord" { i16 60, i16 180, i16 1920, i16 -32 }, %"struct.rally::game::RouteRecord" { i16 180, i16 170, i16 0, i16 0 }, %"struct.rally::game::RouteRecord" { i16 60, i16 180, i16 0, i16 -32 }, %"struct.rally::game::RouteRecord" { i16 60, i16 180, i16 -1920, i16 32 }, %"struct.rally::game::RouteRecord" { i16 180, i16 150, i16 0, i16 0 }], align 1
@_ZN12_GLOBAL__N_113shownRevisionE = internal unnamed_addr global i16 -1, align 1
@_ZN12_GLOBAL__N_110panelCacheE = internal global [2 x [160 x i8]] zeroinitializer, align 1
@_ZN12_GLOBAL__N_110inputArmedE = internal unnamed_addr global i1 false, align 1
@sys_vars = external dso_local local_unnamed_addr global ptr, align 1
@_ZN5rally4gameL9FujiRulesE = internal unnamed_addr constant %"struct.rally::game::Settings" { i16 90, i16 60, i16 85, i16 75, i8 2 }, align 1
@_ZN5rally4gameL9OvalRulesE = internal unnamed_addr constant %"struct.rally::game::Settings" { i16 20, i16 11, i16 20, i16 16, i8 6 }, align 1
@_ZN5rally4gameL9RouteSineE = internal unnamed_addr constant [257 x i16] [i16 0, i16 201, i16 402, i16 603, i16 804, i16 1005, i16 1206, i16 1407, i16 1608, i16 1809, i16 2009, i16 2210, i16 2410, i16 2611, i16 2811, i16 3012, i16 3212, i16 3412, i16 3612, i16 3811, i16 4011, i16 4210, i16 4410, i16 4609, i16 4808, i16 5007, i16 5205, i16 5404, i16 5602, i16 5800, i16 5998, i16 6195, i16 6393, i16 6590, i16 6786, i16 6983, i16 7179, i16 7375, i16 7571, i16 7767, i16 7962, i16 8157, i16 8351, i16 8545, i16 8739, i16 8933, i16 9126, i16 9319, i16 9512, i16 9704, i16 9896, i16 10087, i16 10278, i16 10469, i16 10659, i16 10849, i16 11039, i16 11228, i16 11417, i16 11605, i16 11793, i16 11980, i16 12167, i16 12353, i16 12539, i16 12725, i16 12910, i16 13094, i16 13279, i16 13462, i16 13645, i16 13828, i16 14010, i16 14191, i16 14372, i16 14553, i16 14732, i16 14912, i16 15090, i16 15269, i16 15446, i16 15623, i16 15800, i16 15976, i16 16151, i16 16325, i16 16499, i16 16673, i16 16846, i16 17018, i16 17189, i16 17360, i16 17530, i16 17700, i16 17869, i16 18037, i16 18204, i16 18371, i16 18537, i16 18703, i16 18868, i16 19032, i16 19195, i16 19357, i16 19519, i16 19680, i16 19841, i16 20000, i16 20159, i16 20317, i16 20475, i16 20631, i16 20787, i16 20942, i16 21096, i16 21250, i16 21403, i16 21554, i16 21705, i16 21856, i16 22005, i16 22154, i16 22301, i16 22448, i16 22594, i16 22739, i16 22884, i16 23027, i16 23170, i16 23311, i16 23452, i16 23592, i16 23731, i16 23870, i16 24007, i16 24143, i16 24279, i16 24413, i16 24547, i16 24680, i16 24811, i16 24942, i16 25072, i16 25201, i16 25329, i16 25456, i16 25582, i16 25708, i16 25832, i16 25955, i16 26077, i16 26198, i16 26319, i16 26438, i16 26556, i16 26674, i16 26790, i16 26905, i16 27019, i16 27133, i16 27245, i16 27356, i16 27466, i16 27575, i16 27683, i16 27790, i16 27896, i16 28001, i16 28105, i16 28208, i16 28310, i16 28411, i16 28510, i16 28609, i16 28706, i16 28803, i16 28898, i16 28992, i16 29085, i16 29177, i16 29268, i16 29358, i16 29447, i16 29534, i16 29621, i16 29706, i16 29791, i16 29874, i16 29956, i16 30037, i16 30117, i16 30195, i16 30273, i16 30349, i16 30424, i16 30498, i16 30571, i16 30643, i16 30714, i16 30783, i16 30852, i16 30919, i16 30985, i16 31050, i16 31113, i16 31176, i16 31237, i16 31297, i16 31356, i16 31414, i16 31470, i16 31526, i16 31580, i16 31633, i16 31685, i16 31736, i16 31785, i16 31833, i16 31880, i16 31926, i16 31971, i16 32014, i16 32057, i16 32098, i16 32137, i16 32176, i16 32213, i16 32250, i16 32285, i16 32318, i16 32351, i16 32382, i16 32412, i16 32441, i16 32469, i16 32495, i16 32521, i16 32545, i16 32567, i16 32589, i16 32609, i16 32628, i16 32646, i16 32663, i16 32678, i16 32692, i16 32705, i16 32717, i16 32728, i16 32737, i16 32745, i16 32752, i16 32757, i16 32761, i16 32765, i16 32766, i16 32767], align 1
@__const._ZN5rally4game5Crash4tickERNS_6MotionERKNS0_11RaceTrafficEm.lanes = private unnamed_addr constant [5 x i24] [i24 0, i24 -36, i24 36, i24 -65, i24 65], align 1
@__const._ZN12_GLOBAL__N_110drawPlayerEv.dx = private unnamed_addr constant [8 x i24] [i24 0, i24 7, i24 10, i24 7, i24 0, i24 -7, i24 -10, i24 -7], align 1
@__const._ZN12_GLOBAL__N_110drawPlayerEv.dy = private unnamed_addr constant [8 x i24] [i24 -10, i24 -7, i24 0, i24 7, i24 10, i24 7, i24 0, i24 -7], align 1
@.str.20 = private unnamed_addr constant [15 x i8] c"%d/%s/%d/%u/%d\00", align 1
@.str.21 = private unnamed_addr constant [5 x i8] c"FUJI\00", align 1
@.str.22 = private unnamed_addr constant [5 x i8] c"OVAL\00", align 1
@.str.23 = private unnamed_addr constant [11 x i8] c"AGON RALLY\00", align 1
@.str.24 = private unnamed_addr constant [31 x i8] c"QUALIFY. RACE. BEAT THE CLOCK.\00", align 1
@.str.25 = private unnamed_addr constant [22 x i8] c"PRESS ANY KEY TO RACE\00", align 1
@.str.26 = private unnamed_addr constant [17 x i8] c"CHOOSE YOUR RACE\00", align 1
@.str.27 = private unnamed_addr constant [20 x i8] c"<  FUJI SPEEDWAY  >\00", align 1
@.str.28 = private unnamed_addr constant [19 x i8] c"<    TRI-OVAL    >\00", align 1
@.str.29 = private unnamed_addr constant [25 x i8] c"CIRCUIT RACE  -  UP/DOWN\00", align 1
@.str.30 = private unnamed_addr constant [27 x i8] c"ARCADE TRAFFIC  -  UP/DOWN\00", align 1
@.str.31 = private unnamed_addr constant [23 x i8] c"SPACE / ENTER TO START\00", align 1
@.str.32 = private unnamed_addr constant [19 x i8] c"PREPARE TO QUALIFY\00", align 1
@.str.33 = private unnamed_addr constant [16 x i8] c"PREPARE TO RACE\00", align 1
@.str.34 = private unnamed_addr constant [3 x i8] c"%u\00", align 1
@.str.35 = private unnamed_addr constant [35 x i8] c"UP: GAS   DOWN: BRAKE   L/R: STEER\00", align 1
@.str.36 = private unnamed_addr constant [11 x i8] c"QUALIFIED!\00", align 1
@.str.37 = private unnamed_addr constant [22 x i8] c"GRID POSITION %d OF 7\00", align 1
@.str.38 = private unnamed_addr constant [23 x i8] c"GET READY FOR THE RACE\00", align 1
@.str.39 = private unnamed_addr constant [6 x i8] c"GOAL!\00", align 1
@.str.40 = private unnamed_addr constant [8 x i8] c"TIME UP\00", align 1
@.str.41 = private unnamed_addr constant [16 x i8] c"DID NOT QUALIFY\00", align 1
@.str.42 = private unnamed_addr constant [12 x i8] c"BEST LAP %s\00", align 1
@.str.43 = private unnamed_addr constant [25 x i8] c"SPACE / ENTER: TRY AGAIN\00", align 1
@.str.44 = private unnamed_addr constant [11 x i8] c"ESC: TITLE\00", align 1
@.str.45 = private unnamed_addr constant [18 x i8] c"%01lu'%02lu\22%02lu\00", align 1
@.str.46 = private unnamed_addr constant [10 x i8] c"TOP %07lu\00", align 1
@.str.47 = private unnamed_addr constant [11 x i8] c"TIME %03lu\00", align 1
@.str.48 = private unnamed_addr constant [7 x i8] c"LAP %s\00", align 1
@.str.49 = private unnamed_addr constant [12 x i8] c"SCORE %07lu\00", align 1
@.str.50 = private unnamed_addr constant [12 x i8] c"SPEED %03ld\00", align 1
@.str.51 = private unnamed_addr constant [9 x i8] c"POS %d/7\00", align 1
@_ZN12_GLOBAL__N_13hudE = internal global %"struct.rally::game::Hud" { [2 x %"struct.rally::game::HudImage"] [%"struct.rally::game::HudImage" { [120 x i8] c"                                                                                                                        ", [120 x i8] c"\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F" }, %"struct.rally::game::HudImage" { [120 x i8] c"                                                                                                                        ", [120 x i8] c"\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F" }], [2 x i8] zeroinitializer }, align 1
@.str.52 = private unnamed_addr constant [32 x i8] c"ARROWS DRIVE   -= GRIP   M MUTE\00", align 1
@.str.53 = private unnamed_addr constant [15 x i8] c"QUALIFYING LAP\00", align 1
@.str.54 = private unnamed_addr constant [14 x i8] c"%s  LAP %u/%u\00", align 1
@.str.55 = private unnamed_addr constant [5 x i8] c"RACE\00", align 1
@.str.56 = private unnamed_addr constant [7 x i8] c"ARCADE\00", align 1
@.str.57 = private unnamed_addr constant [15 x i8] c"TIME EXTENDED!\00", align 1
@.str.58 = private unnamed_addr constant [10 x i8] c"rally.new\00", align 1
@.str.59 = private unnamed_addr constant [3 x i8] c"wb\00", align 1
@__const._ZN5rally4game6Engine4stopIPFvPKhjEEEvT_.mute = private unnamed_addr constant [6 x i8] c"\17\00\85\00\02\00", align 1
@__const._ZN5rally4game6Engine5startIPFvPKhjEEEvT_.setup = private unnamed_addr constant [16 x i8] c"\17\00\85\00\08\17\00\85\00\0A\17\00\85\00\04\03", align 1
@__const._ZN5rally4game6Engine5startIPFvPKhjEEEvT_.volume = private unnamed_addr constant [6 x i8] c"\17\00\85\00\02(", align 1
@_ZN5rallyL11BandOffsetsE = internal unnamed_addr constant [2408 x i16] [i16 0, i16 8, i16 16, i16 25, i16 34, i16 43, i16 52, i16 62, i16 72, i16 81, i16 91, i16 101, i16 111, i16 121, i16 131, i16 141, i16 151, i16 161, i16 172, i16 183, i16 194, i16 204, i16 215, i16 225, i16 236, i16 248, i16 260, i16 273, i16 287, i16 300, i16 314, i16 328, i16 343, i16 357, i16 373, i16 386, i16 401, i16 415, i16 432, i16 447, i16 463, i16 476, i16 490, i16 505, i16 520, i16 535, i16 550, i16 566, i16 583, i16 599, i16 615, i16 632, i16 650, i16 666, i16 681, i16 697, i16 713, i16 727, i16 742, i16 759, i16 776, i16 792, i16 808, i16 826, i16 845, i16 861, i16 877, i16 895, i16 914, i16 931, i16 946, i16 963, i16 982, i16 998, i16 1013, i16 1027, i16 1045, i16 1061, i16 1076, i16 1091, i16 1108, i16 1122, i16 1136, i16 1152, i16 1168, i16 1183, i16 1198, i16 1213, i16 1228, i16 1241, i16 1257, i16 1273, i16 1289, i16 1304, i16 1319, i16 1335, i16 1353, i16 1368, i16 1382, i16 1398, i16 1414, i16 1427, i16 1441, i16 1455, i16 1471, i16 1484, i16 1497, i16 1511, i16 1525, i16 1537, i16 1549, i16 1562, i16 1575, i16 1585, i16 1596, i16 1606, i16 1618, i16 1627, i16 1636, i16 1645, i16 1654, i16 1661, i16 1668, i16 1676, i16 1684, i16 1690, i16 1697, i16 1704, i16 1711, i16 1716, i16 1722, i16 1728, i16 1733, i16 1738, i16 1743, i16 1748, i16 1753, i16 1757, i16 1761, i16 1765, i16 1769, i16 1771, i16 1773, i16 1775, i16 1777, i16 1778, i16 1779, i16 1780, i16 1781, i16 1782, i16 1783, i16 1784, i16 1785, i16 1786, i16 1787, i16 1789, i16 1791, i16 1793, i16 1795, i16 1797, i16 1799, i16 1801, i16 1804, i16 1807, i16 1810, i16 1813, i16 1816, i16 1820, i16 1824, i16 1828, i16 1832, i16 1836, i16 1841, i16 1845, i16 1849, i16 1853, i16 1858, i16 1863, i16 1868, i16 1873, i16 1878, i16 1884, i16 1890, i16 1896, i16 1903, i16 1909, i16 1916, i16 1923, i16 1931, i16 1939, i16 1947, i16 1955, i16 1963, i16 1972, i16 1981, i16 1991, i16 2001, i16 2011, i16 2022, i16 2033, i16 2044, i16 2056, i16 2069, i16 2082, i16 2096, i16 2110, i16 2124, i16 2137, i16 2152, i16 2166, i16 2182, i16 2196, i16 2212, i16 2227, i16 2241, i16 2255, i16 2270, i16 2283, i16 2298, i16 2313, i16 2329, i16 2343, i16 2358, i16 2375, i16 2393, i16 2409, i16 2425, i16 2443, i16 2461, i16 2476, i16 2491, i16 2507, i16 2523, i16 2538, i16 2556, i16 2574, i16 2592, i16 2608, i16 2624, i16 2641, i16 2660, i16 2676, i16 2692, i16 2709, i16 2727, i16 2743, i16 2759, i16 2776, i16 2793, i16 2808, i16 2822, i16 2837, i16 2854, i16 2869, i16 2882, i16 2897, i16 2914, i16 2929, i16 2943, i16 2959, i16 2976, i16 2990, i16 3005, i16 3021, i16 3037, i16 3050, i16 3065, i16 3080, i16 3097, i16 3112, i16 3126, i16 3140, i16 3157, i16 3172, i16 3186, i16 3201, i16 3217, i16 3231, i16 3245, i16 3259, i16 3275, i16 3289, i16 3302, i16 3316, i16 3331, i16 3343, i16 3355, i16 3367, i16 3379, i16 3390, i16 3401, i16 3413, i16 3424, i16 3433, i16 3443, i16 3454, i16 3465, i16 3475, i16 3485, i16 3495, i16 3506, i16 3515, i16 3524, i16 3533, i16 3542, i16 3550, i16 3558, i16 3566, i16 3574, i16 3583, i16 3591, i16 3600, i16 3607, i16 3614, i16 3622, i16 3630, i16 3638, i16 3645, i16 3652, i16 3660, i16 3668, i16 3675, i16 3682, i16 3690, i16 3698, i16 3705, i16 3712, i16 3719, i16 3726, i16 3734, i16 3742, i16 3750, i16 3757, i16 3764, i16 3772, i16 3780, i16 3788, i16 3796, i16 3804, i16 3812, i16 3820, i16 3828, i16 3836, i16 3844, i16 3853, i16 3861, i16 3869, i16 3878, i16 3887, i16 3895, i16 3903, i16 3912, i16 3921, i16 3930, i16 3939, i16 3948, i16 3957, i16 3965, i16 3974, i16 3983, i16 3992, i16 3993, i16 3994, i16 3995, i16 3996, i16 3997, i16 3998, i16 3999, i16 4000, i16 4001, i16 4002, i16 4003, i16 4004, i16 4005, i16 4006, i16 4007, i16 4008, i16 4009, i16 4010, i16 4011, i16 4012, i16 4013, i16 4014, i16 4015, i16 4016, i16 4017, i16 4018, i16 4019, i16 4020, i16 4021, i16 4022, i16 4023, i16 4024, i16 4025, i16 4026, i16 4027, i16 4028, i16 4029, i16 4030, i16 4031, i16 4032, i16 4033, i16 4034, i16 4035, i16 4036, i16 4037, i16 4038, i16 4039, i16 4040, i16 4041, i16 4042, i16 4043, i16 4044, i16 4045, i16 4046, i16 4047, i16 4048, i16 4049, i16 4050, i16 4051, i16 4052, i16 4053, i16 4054, i16 4055, i16 4056, i16 4057, i16 4058, i16 4059, i16 4060, i16 4061, i16 4062, i16 4063, i16 4064, i16 4065, i16 4066, i16 4067, i16 4068, i16 4069, i16 4070, i16 4071, i16 4072, i16 4073, i16 4074, i16 4075, i16 4076, i16 4077, i16 4078, i16 4079, i16 4080, i16 4081, i16 4082, i16 4083, i16 4084, i16 4085, i16 4086, i16 4087, i16 4088, i16 4089, i16 4090, i16 4091, i16 4092, i16 4093, i16 4094, i16 4095, i16 4096, i16 4097, i16 4098, i16 4099, i16 4100, i16 4101, i16 4102, i16 4103, i16 4104, i16 4105, i16 4106, i16 4107, i16 4108, i16 4109, i16 4110, i16 4111, i16 4112, i16 4113, i16 4114, i16 4115, i16 4116, i16 4117, i16 4118, i16 4119, i16 4120, i16 4121, i16 4122, i16 4123, i16 4124, i16 4125, i16 4126, i16 4127, i16 4128, i16 4129, i16 4130, i16 4131, i16 4132, i16 4133, i16 4134, i16 4135, i16 4136, i16 4137, i16 4138, i16 4139, i16 4140, i16 4141, i16 4142, i16 4143, i16 4144, i16 4145, i16 4146, i16 4147, i16 4148, i16 4149, i16 4150, i16 4151, i16 4152, i16 4153, i16 4154, i16 4155, i16 4156, i16 4157, i16 4158, i16 4159, i16 4160, i16 4161, i16 4162, i16 4163, i16 4164, i16 4165, i16 4166, i16 4167, i16 4168, i16 4169, i16 4170, i16 4171, i16 4172, i16 4173, i16 4174, i16 4175, i16 4176, i16 4177, i16 4178, i16 4179, i16 4180, i16 4181, i16 4182, i16 4183, i16 4184, i16 4185, i16 4186, i16 4187, i16 4188, i16 4189, i16 4190, i16 4191, i16 4192, i16 4193, i16 4194, i16 4195, i16 4196, i16 4197, i16 4198, i16 4199, i16 4200, i16 4201, i16 4202, i16 4203, i16 4204, i16 4205, i16 4206, i16 4207, i16 4208, i16 4209, i16 4210, i16 4211, i16 4212, i16 4213, i16 4214, i16 4215, i16 4216, i16 4217, i16 4218, i16 4219, i16 4220, i16 4221, i16 4222, i16 4223, i16 4224, i16 4225, i16 4226, i16 4227, i16 4228, i16 4229, i16 4230, i16 4231, i16 4232, i16 4233, i16 4234, i16 4235, i16 4236, i16 4237, i16 4238, i16 4239, i16 4240, i16 4241, i16 4242, i16 4243, i16 4244, i16 4245, i16 4246, i16 4247, i16 4248, i16 4249, i16 4250, i16 4251, i16 4252, i16 4253, i16 4254, i16 4256, i16 4258, i16 4260, i16 4262, i16 4264, i16 4266, i16 4268, i16 4271, i16 4274, i16 4277, i16 4280, i16 4283, i16 4287, i16 4291, i16 4295, i16 4299, i16 4303, i16 4308, i16 4313, i16 4318, i16 4324, i16 4330, i16 4336, i16 4343, i16 4350, i16 4356, i16 4364, i16 4371, i16 4379, i16 4386, i16 4395, i16 4403, i16 4412, i16 4421, i16 4431, i16 4441, i16 4450, i16 4460, i16 4470, i16 4482, i16 4493, i16 4505, i16 4517, i16 4529, i16 4541, i16 4555, i16 4568, i16 4583, i16 4598, i16 4614, i16 4629, i16 4644, i16 4659, i16 4674, i16 4689, i16 4704, i16 4721, i16 4737, i16 4752, i16 4767, i16 4783, i16 4799, i16 4812, i16 4826, i16 4841, i16 4858, i16 4872, i16 4887, i16 4902, i16 4918, i16 4932, i16 4945, i16 4959, i16 4976, i16 4991, i16 5005, i16 5021, i16 5037, i16 5052, i16 5066, i16 5082, i16 5098, i16 5111, i16 5125, i16 5140, i16 5157, i16 5172, i16 5186, i16 5202, i16 5219, i16 5234, i16 5247, i16 5263, i16 5279, i16 5294, i16 5308, i16 5324, i16 5341, i16 5356, i16 5370, i16 5385, i16 5402, i16 5417, i16 5430, i16 5446, i16 5463, i16 5477, i16 5491, i16 5506, i16 5522, i16 5537, i16 5551, i16 5566, i16 5582, i16 5597, i16 5611, i16 5626, i16 5643, i16 5658, i16 5672, i16 5688, i16 5704, i16 5719, i16 5733, i16 5748, i16 5764, i16 5778, i16 5792, i16 5807, i16 5822, i16 5836, i16 5849, i16 5862, i16 5876, i16 5889, i16 5902, i16 5915, i16 5928, i16 5938, i16 5950, i16 5962, i16 5975, i16 5986, i16 5997, i16 6007, i16 6019, i16 6029, i16 6039, i16 6050, i16 6061, i16 6069, i16 6077, i16 6085, i16 6094, i16 6101, i16 6108, i16 6115, i16 6122, i16 6128, i16 6134, i16 6141, i16 6147, i16 6152, i16 6157, i16 6162, i16 6167, i16 6171, i16 6176, i16 6181, i16 6186, i16 6190, i16 6194, i16 6198, i16 6202, i16 6205, i16 6209, i16 6213, i16 6218, i16 6222, i16 6226, i16 6230, i16 6234, i16 6238, i16 6242, i16 6246, i16 6250, i16 6253, i16 6256, i16 6259, i16 6263, i16 6267, i16 6271, i16 6275, i16 6279, i16 6283, i16 6287, i16 6291, i16 6294, i16 6298, i16 6302, i16 6306, i16 6311, i16 6316, i16 6321, i16 6326, i16 6331, i16 6336, i16 6341, i16 6346, i16 6352, i16 6357, i16 6362, i16 6367, i16 6372, i16 6377, i16 6383, i16 6389, i16 6395, i16 6401, i16 6407, i16 6412, i16 6418, i16 6424, i16 6430, i16 6436, i16 6443, i16 6450, i16 6457, i16 6464, i16 6471, i16 6478, i16 6485, i16 6492, i16 6499, i16 6506, i16 6514, i16 6522, i16 6529, i16 6537, i16 6545, i16 6553, i16 6561, i16 6569, i16 6577, i16 6586, i16 6594, i16 6603, i16 6612, i16 6621, i16 6630, i16 6639, i16 6648, i16 6657, i16 6666, i16 6675, i16 6685, i16 6695, i16 6705, i16 6715, i16 6725, i16 6736, i16 6747, i16 6758, i16 6769, i16 6781, i16 6793, i16 6804, i16 6815, i16 6827, i16 6839, i16 6850, i16 6862, i16 6875, i16 6888, i16 6900, i16 6911, i16 6922, i16 6934, i16 6945, i16 6957, i16 6969, i16 6982, i16 6993, i16 7005, i16 7017, i16 7029, i16 7041, i16 7053, i16 7065, i16 7077, i16 7088, i16 7099, i16 7111, i16 7122, i16 7133, i16 7145, i16 7156, i16 7167, i16 7178, i16 7189, i16 7201, i16 7214, i16 7225, i16 7235, i16 7246, i16 7258, i16 7268, i16 7278, i16 7288, i16 7299, i16 7308, i16 7318, i16 7328, i16 7339, i16 7348, i16 7357, i16 7367, i16 7376, i16 7384, i16 7392, i16 7400, i16 7408, i16 7414, i16 7420, i16 7426, i16 7432, i16 7437, i16 7442, i16 7448, i16 7453, i16 7458, i16 7463, i16 7469, i16 7474, i16 7478, i16 7482, i16 7486, i16 7490, i16 7494, i16 7498, i16 7503, i16 7507, i16 7510, i16 7513, i16 7516, i16 7519, i16 7523, i16 7527, i16 7531, i16 7535, i16 7538, i16 7541, i16 7544, i16 7547, i16 7550, i16 7553, i16 7556, i16 7559, i16 7562, i16 7565, i16 7568, i16 7571, i16 7574, i16 7577, i16 7580, i16 7583, i16 7586, i16 7589, i16 7592, i16 7595, i16 7598, i16 7601, i16 7604, i16 7607, i16 7610, i16 7614, i16 7617, i16 7620, i16 7624, i16 7628, i16 7632, i16 7636, i16 7640, i16 7644, i16 7649, i16 7653, i16 7657, i16 7661, i16 7664, i16 7667, i16 7671, i16 7675, i16 7680, i16 7685, i16 7690, i16 7696, i16 7702, i16 7708, i16 7713, i16 7718, i16 7723, i16 7729, i16 7734, i16 7739, i16 7745, i16 7751, i16 7756, i16 7761, i16 7766, i16 7771, i16 7776, i16 7782, i16 7788, i16 7794, i16 7800, i16 7806, i16 7811, i16 7817, i16 7823, i16 7830, i16 7837, i16 7844, i16 7850, i16 7857, i16 7864, i16 7871, i16 7877, i16 7884, i16 7891, i16 7898, i16 7905, i16 7912, i16 7919, i16 7926, i16 7934, i16 7942, i16 7950, i16 7958, i16 7966, i16 7975, i16 7984, i16 7993, i16 8001, i16 8010, i16 8019, i16 8028, i16 8038, i16 8048, i16 8058, i16 8068, i16 8078, i16 8088, i16 8099, i16 8111, i16 8123, i16 8136, i16 8148, i16 8161, i16 8172, i16 8185, i16 8197, i16 8210, i16 8223, i16 8237, i16 8251, i16 8265, i16 8278, i16 8291, i16 8305, i16 8319, i16 8334, i16 8350, i16 8365, i16 8381, i16 8395, i16 8408, i16 8421, i16 8436, i16 8450, i16 8464, i16 8478, i16 8493, i16 8508, i16 8523, i16 8539, i16 8555, i16 8569, i16 8584, i16 8600, i16 8616, i16 8632, i16 8646, i16 8661, i16 8677, i16 8691, i16 8705, i16 8721, i16 8738, i16 8752, i16 8765, i16 8780, i16 8794, i16 8807, i16 8822, i16 8838, i16 8854, i16 8868, i16 8882, i16 8897, i16 8913, i16 8927, i16 8941, i16 8957, i16 8973, i16 8986, i16 9000, i16 9015, i16 9030, i16 9044, i16 9058, i16 9072, i16 9087, i16 9100, i16 9115, i16 9130, i16 9147, i16 9161, i16 9175, i16 9190, i16 9206, i16 9220, i16 9235, i16 9251, i16 9268, i16 9281, i16 9294, i16 9307, i16 9322, i16 9335, i16 9350, i16 9366, i16 9381, i16 9395, i16 9408, i16 9422, i16 9437, i16 9451, i16 9464, i16 9478, i16 9493, i16 9506, i16 9518, i16 9532, i16 9546, i16 9557, i16 9568, i16 9581, i16 9594, i16 9605, i16 9618, i16 9631, i16 9644, i16 9654, i16 9664, i16 9675, i16 9686, i16 9695, i16 9705, i16 9715, i16 9725, i16 9732, i16 9740, i16 9749, i16 9757, i16 9763, i16 9769, i16 9775, i16 9781, i16 9787, i16 9793, i16 9799, i16 9805, i16 9812, i16 9819, i16 9826, i16 9833, i16 9839, i16 9845, i16 9852, i16 9858, i16 9864, i16 9870, i16 9876, i16 9882, i16 9887, i16 9892, i16 9897, i16 9902, i16 9906, i16 9910, i16 9914, i16 9918, i16 9922, i16 9926, i16 9930, i16 9934, i16 9938, i16 9942, i16 9946, i16 9950, i16 9954, i16 9958, i16 9962, i16 9966, i16 9970, i16 9974, i16 9978, i16 9981, i16 9984, i16 9987, i16 9990, i16 9993, i16 9996, i16 9999, i16 10002, i16 10005, i16 10007, i16 10009, i16 10011, i16 10013, i16 10015, i16 10017, i16 10020, i16 10024, i16 10027, i16 10030, i16 10033, i16 10036, i16 10039, i16 10042, i16 10045, i16 10048, i16 10051, i16 10055, i16 10059, i16 10063, i16 10067, i16 10071, i16 10075, i16 10079, i16 10083, i16 10087, i16 10092, i16 10097, i16 10102, i16 10107, i16 10112, i16 10117, i16 10122, i16 10128, i16 10134, i16 10140, i16 10147, i16 10154, i16 10160, i16 10168, i16 10176, i16 10184, i16 10193, i16 10202, i16 10211, i16 10220, i16 10229, i16 10238, i16 10247, i16 10257, i16 10267, i16 10277, i16 10288, i16 10298, i16 10308, i16 10319, i16 10330, i16 10343, i16 10355, i16 10367, i16 10378, i16 10391, i16 10402, i16 10416, i16 10428, i16 10441, i16 10453, i16 10467, i16 10480, i16 10494, i16 10509, i16 10525, i16 10541, i16 10558, i16 10574, i16 10590, i16 10607, i16 10626, i16 10644, i16 10663, i16 10681, i16 10702, i16 10723, i16 10744, i16 10763, i16 10783, i16 10803, i16 10825, i16 10844, i16 10864, i16 10884, i16 10907, i16 10925, i16 10943, i16 10960, i16 10979, i16 10994, i16 11009, i16 11025, i16 11044, i16 11056, i16 11069, i16 11083, i16 11099, i16 11111, i16 11125, i16 11140, i16 11157, i16 11169, i16 11181, i16 11194, i16 11209, i16 11221, i16 11233, i16 11247, i16 11262, i16 11274, i16 11285, i16 11297, i16 11309, i16 11318, i16 11327, i16 11337, i16 11348, i16 11357, i16 11365, i16 11373, i16 11382, i16 11389, i16 11396, i16 11403, i16 11410, i16 11415, i16 11419, i16 11423, i16 11427, i16 11430, i16 11433, i16 11436, i16 11439, i16 11442, i16 11445, i16 11448, i16 11451, i16 11454, i16 11457, i16 11460, i16 11463, i16 11466, i16 11469, i16 11472, i16 11475, i16 11478, i16 11481, i16 11484, i16 11487, i16 11489, i16 11491, i16 11493, i16 11495, i16 11497, i16 11499, i16 11501, i16 11503, i16 11505, i16 11507, i16 11509, i16 11511, i16 11513, i16 11516, i16 11519, i16 11522, i16 11525, i16 11528, i16 11531, i16 11534, i16 11537, i16 11540, i16 11544, i16 11548, i16 11552, i16 11556, i16 11560, i16 11564, i16 11568, i16 11572, i16 11575, i16 11579, i16 11583, i16 11586, i16 11590, i16 11594, i16 11598, i16 11602, i16 11606, i16 11610, i16 11614, i16 11618, i16 11622, i16 11626, i16 11629, i16 11632, i16 11636, i16 11640, i16 11644, i16 11648, i16 11652, i16 11656, i16 11660, i16 11664, i16 11669, i16 11674, i16 11679, i16 11684, i16 11689, i16 11694, i16 11698, i16 11702, i16 11706, i16 11710, i16 11714, i16 11719, i16 11724, i16 11729, i16 11734, i16 11739, i16 11744, i16 11749, i16 11754, i16 11759, i16 11764, i16 11769, i16 11774, i16 11779, i16 11784, i16 11789, i16 11795, i16 11801, i16 11807, i16 11813, i16 11819, i16 11825, i16 11831, i16 11837, i16 11843, i16 11849, i16 11855, i16 11860, i16 11866, i16 11872, i16 11878, i16 11884, i16 11890, i16 11896, i16 11903, i16 11910, i16 11916, i16 11923, i16 11930, i16 11937, i16 11944, i16 11952, i16 11960, i16 11968, i16 11976, i16 11984, i16 11993, i16 12001, i16 12008, i16 12016, i16 12024, i16 12032, i16 12040, i16 12048, i16 12056, i16 12064, i16 12071, i16 12078, i16 12085, i16 12092, i16 12100, i16 12108, i16 12116, i16 12124, i16 12132, i16 12140, i16 12148, i16 12157, i16 12166, i16 12175, i16 12184, i16 12193, i16 12202, i16 12211, i16 12220, i16 12229, i16 12237, i16 12245, i16 12253, i16 12262, i16 12271, i16 12280, i16 12289, i16 12298, i16 12308, i16 12318, i16 12328, i16 12338, i16 12346, i16 12355, i16 12364, i16 12373, i16 12382, i16 12391, i16 12400, i16 12408, i16 12415, i16 12423, i16 12431, i16 12441, i16 12449, i16 12457, i16 12466, i16 12475, i16 12483, i16 12491, i16 12499, i16 12507, i16 12515, i16 12523, i16 12531, i16 12539, i16 12547, i16 12556, i16 12566, i16 12575, i16 12583, i16 12591, i16 12599, i16 12607, i16 12615, i16 12624, i16 12633, i16 12641, i16 12648, i16 12655, i16 12662, i16 12669, i16 12676, i16 12683, i16 12691, i16 12699, i16 12707, i16 12715, i16 12723, i16 12731, i16 12737, i16 12744, i16 12750, i16 12756, i16 12762, i16 12770, i16 12778, i16 12785, i16 12792, i16 12799, i16 12805, i16 12811, i16 12817, i16 12823, i16 12831, i16 12839, i16 12846, i16 12853, i16 12860, i16 12866, i16 12872, i16 12878, i16 12884, i16 12890, i16 12895, i16 12900, i16 12905, i16 12911, i16 12918, i16 12925, i16 12932, i16 12939, i16 12945, i16 12951, i16 12957, i16 12963, i16 12969, i16 12975, i16 12982, i16 12988, i16 12994, i16 13001, i16 13008, i16 13015, i16 13021, i16 13027, i16 13033, i16 13039, i16 13045, i16 13051, i16 13058, i16 13065, i16 13072, i16 13079, i16 13086, i16 13092, i16 13098, i16 13104, i16 13111, i16 13118, i16 13125, i16 13132, i16 13139, i16 13145, i16 13151, i16 13157, i16 13164, i16 13171, i16 13178, i16 13185, i16 13192, i16 13199, i16 13206, i16 13213, i16 13220, i16 13227, i16 13234, i16 13241, i16 13248, i16 13255, i16 13261, i16 13267, i16 13273, i16 13279, i16 13285, i16 13291, i16 13297, i16 13304, i16 13309, i16 13315, i16 13321, i16 13327, i16 13333, i16 13339, i16 13345, i16 13352, i16 13358, i16 13364, i16 13370, i16 13376, i16 13382, i16 13388, i16 13394, i16 13400, i16 13406, i16 13412, i16 13418, i16 13424, i16 13430, i16 13436, i16 13442, i16 13448, i16 13454, i16 13460, i16 13466, i16 13472, i16 13478, i16 13484, i16 13490, i16 13496, i16 13501, i16 13506, i16 13511, i16 13516, i16 13521, i16 13525, i16 13529, i16 13534, i16 13539, i16 13544, i16 13549, i16 13554, i16 13559, i16 13564, i16 13569, i16 13574, i16 13580, i16 13586, i16 13592, i16 13598, i16 13604, i16 13610, i16 13616, i16 13621, i16 13626, i16 13631, i16 13637, i16 13643, i16 13649, i16 13655, i16 13661, i16 13668, i16 13674, i16 13679, i16 13685, i16 13691, i16 13697, i16 13703, i16 13709, i16 13716, i16 13723, i16 13730, i16 13738, i16 13746, i16 13753, i16 13760, i16 13767, i16 13774, i16 13782, i16 13790, i16 13798, i16 13806, i16 13814, i16 13822, i16 13830, i16 13838, i16 13846, i16 13854, i16 13862, i16 13870, i16 13878, i16 13886, i16 13894, i16 13902, i16 13911, i16 13920, i16 13929, i16 13938, i16 13946, i16 13955, i16 13964, i16 13973, i16 13981, i16 13990, i16 14000, i16 14009, i16 14018, i16 14027, i16 14036, i16 14044, i16 14053, i16 14062, i16 14072, i16 14082, i16 14091, i16 14101, i16 14111, i16 14121, i16 14130, i16 14139, i16 14148, i16 14157, i16 14166, i16 14175, i16 14184, i16 14193, i16 14201, i16 14209, i16 14217, i16 14226, i16 14234, i16 14244, i16 14254, i16 14263, i16 14271, i16 14279, i16 14287, i16 14295, i16 14303, i16 14312, i16 14321, i16 14329, i16 14336, i16 14343, i16 14350, i16 14358, i16 14366, i16 14374, i16 14383, i16 14391, i16 14398, i16 14405, i16 14412, i16 14419, i16 14425, i16 14432, i16 14439, i16 14445, i16 14451, i16 14457, i16 14464, i16 14471, i16 14477, i16 14484, i16 14492, i16 14499, i16 14505, i16 14512, i16 14519, i16 14526, i16 14532, i16 14538, i16 14544, i16 14551, i16 14557, i16 14563, i16 14569, i16 14575, i16 14581, i16 14587, i16 14594, i16 14601, i16 14607, i16 14613, i16 14619, i16 14625, i16 14631, i16 14637, i16 14643, i16 14649, i16 14655, i16 14661, i16 14667, i16 14673, i16 14679, i16 14685, i16 14692, i16 14699, i16 14706, i16 14713, i16 14720, i16 14726, i16 14732, i16 14738, i16 14744, i16 14750, i16 14756, i16 14762, i16 14768, i16 14774, i16 14780, i16 14786, i16 14793, i16 14800, i16 14806, i16 14812, i16 14818, i16 14824, i16 14830, i16 14836, i16 14843, i16 14850, i16 14856, i16 14862, i16 14868, i16 14874, i16 14881, i16 14887, i16 14893, i16 14900, i16 14907, i16 14914, i16 14921, i16 14928, i16 14935, i16 14941, i16 14947, i16 14954, i16 14961, i16 14969, i16 14977, i16 14985, i16 14992, i16 14999, i16 15006, i16 15014, i16 15022, i16 15030, i16 15039, i16 15047, i16 15056, i16 15065, i16 15074, i16 15082, i16 15090, i16 15099, i16 15108, i16 15117, i16 15125, i16 15134, i16 15144, i16 15154, i16 15164, i16 15174, i16 15184, i16 15194, i16 15203, i16 15213, i16 15223, i16 15233, i16 15241, i16 15249, i16 15258, i16 15267, i16 15276, i16 15286, i16 15296, i16 15306, i16 15316, i16 15326, i16 15337, i16 15348, i16 15358, i16 15368, i16 15379, i16 15390, i16 15401, i16 15411, i16 15422, i16 15434, i16 15445, i16 15458, i16 15471, i16 15483, i16 15494, i16 15507, i16 15519, i16 15531, i16 15542, i16 15553, i16 15565, i16 15577, i16 15590, i16 15602, i16 15616, i16 15629, i16 15642, i16 15655, i16 15668, i16 15681, i16 15693, i16 15706, i16 15720, i16 15733, i16 15746, i16 15759, i16 15772, i16 15784, i16 15797, i16 15809, i16 15822, i16 15834, i16 15847, i16 15861, i16 15874, i16 15888, i16 15901, i16 15914, i16 15927, i16 15942, i16 15954, i16 15967, i16 15980, i16 15994, i16 16007, i16 16020, i16 16034, i16 16048, i16 16060, i16 16074, i16 16087, i16 16099, i16 16111, i16 16124, i16 16137, i16 16150, i16 16162, i16 16175, i16 16187, i16 16200, i16 16211, i16 16222, i16 16233, i16 16244, i16 16254, i16 16264, i16 16274, i16 16284, i16 16293, i16 16302, i16 16311, i16 16321, i16 16330, i16 16339, i16 16348, i16 16356, i16 16363, i16 16371, i16 16378, i16 16385, i16 16392, i16 16399, i16 16406, i16 16412, i16 16417, i16 16423, i16 16430, i16 16436, i16 16441, i16 16446, i16 16451, i16 16456, i16 16459, i16 16462, i16 16465, i16 16468, i16 16471, i16 16474, i16 16477, i16 16479, i16 16480, i16 16481, i16 16482, i16 16483, i16 16484, i16 16485, i16 16486, i16 16487, i16 16488, i16 16489, i16 16490, i16 16491, i16 16492, i16 16493, i16 16494, i16 16495, i16 16496, i16 16497, i16 16498, i16 16499, i16 16500, i16 16501, i16 16502, i16 16503, i16 16504, i16 16505, i16 16506, i16 16507, i16 16508, i16 16509, i16 16510, i16 16511, i16 16512, i16 16513, i16 16514, i16 16515, i16 16516, i16 16517, i16 16518, i16 16519, i16 16520, i16 16521, i16 16522, i16 16523, i16 16524, i16 16525, i16 16526, i16 16527, i16 16528, i16 16529, i16 16530, i16 16531, i16 16532, i16 16533, i16 16534, i16 16535, i16 16536, i16 16537, i16 16538, i16 16539, i16 16540, i16 16541, i16 16542, i16 16543, i16 16544, i16 16545, i16 16546, i16 16547, i16 16548, i16 16549, i16 16550, i16 16551, i16 16552, i16 16553, i16 16554, i16 16555, i16 16556, i16 16557, i16 16558, i16 16559, i16 16560, i16 16561, i16 16562, i16 16563, i16 16564, i16 16565, i16 16566, i16 16567, i16 16568, i16 16569, i16 16570, i16 16571, i16 16572, i16 16573, i16 16574, i16 16575, i16 16576, i16 16577, i16 16578, i16 16579, i16 16580, i16 16581, i16 16582, i16 16583, i16 16584, i16 16585, i16 16586, i16 16587, i16 16588, i16 16589, i16 16590, i16 16591, i16 16592, i16 16593, i16 16594, i16 16595, i16 16596, i16 16597, i16 16598, i16 16599, i16 16600, i16 16601, i16 16602, i16 16603, i16 16604, i16 16605, i16 16606, i16 16607, i16 16608, i16 16609, i16 16610, i16 16611, i16 16612, i16 16613, i16 16614, i16 16615, i16 16616, i16 16617, i16 16618, i16 16619, i16 16620, i16 16621, i16 16622, i16 16623, i16 16624, i16 16625, i16 16626, i16 16627, i16 16628, i16 16629, i16 16630, i16 16631, i16 16632, i16 16633, i16 16634, i16 16635, i16 16636, i16 16637, i16 16638, i16 16639, i16 16640, i16 16641, i16 16642, i16 16643, i16 16644, i16 16645, i16 16646, i16 16647, i16 16648, i16 16649, i16 16650, i16 16651, i16 16652, i16 16653, i16 16654, i16 16655, i16 16656, i16 16657, i16 16658, i16 16659, i16 16660, i16 16661, i16 16662, i16 16663, i16 16664, i16 16665, i16 16666, i16 16667, i16 16668, i16 16669, i16 16670, i16 16671, i16 16672, i16 16673, i16 16674, i16 16675, i16 16676, i16 16677, i16 16678, i16 16679, i16 16680, i16 16681, i16 16682, i16 16683, i16 16684, i16 16685, i16 16686, i16 16687, i16 16688, i16 16689, i16 16690, i16 16691, i16 16692, i16 16693, i16 16694, i16 16695, i16 16696, i16 16697, i16 16698, i16 16699, i16 16700, i16 16701, i16 16702, i16 16703, i16 16704, i16 16705, i16 16706, i16 16707, i16 16708, i16 16709, i16 16710, i16 16711, i16 16712, i16 16713, i16 16714, i16 16715, i16 16716, i16 16717, i16 16718, i16 16719, i16 16720, i16 16721, i16 16722, i16 16723, i16 16724, i16 16725, i16 16726, i16 16727, i16 16728, i16 16729, i16 16730, i16 16731, i16 16732, i16 16733, i16 16734, i16 16735, i16 16736, i16 16737, i16 16738, i16 16739, i16 16740, i16 16741, i16 16742, i16 16743, i16 16744, i16 16745, i16 16746, i16 16747, i16 16748, i16 16749, i16 16750, i16 16751, i16 16752, i16 16753, i16 16754, i16 16755, i16 16756, i16 16757, i16 16758, i16 16759, i16 16760, i16 16761, i16 16762, i16 16763, i16 16764, i16 16765, i16 16766, i16 16767, i16 16768, i16 16769, i16 16770, i16 16771, i16 16772, i16 16773, i16 16774, i16 16775, i16 16776, i16 16777, i16 16778, i16 16779, i16 16780, i16 16781, i16 16782, i16 16783, i16 16784, i16 16785, i16 16786, i16 16787, i16 16788, i16 16789, i16 16790, i16 16791, i16 16792, i16 16793, i16 16794, i16 16795, i16 16796, i16 16797, i16 16798, i16 16799, i16 16800, i16 16801, i16 16802], align 1
@_ZN5rallyL11HeadingAtanE = internal unnamed_addr constant [257 x i8] c"\00\01\01\02\03\03\04\04\05\06\06\07\08\08\09\0A\0A\0B\0B\0C\0D\0D\0E\0F\0F\10\10\11\12\12\13\14\14\15\16\16\17\17\18\19\19\1A\1B\1B\1C\1C\1D\1E\1E\1F\1F !!\22\22#$$%&&''())**+,,--../001123344556778899::;<<==>>??@AABBCCDDEEFFGGHHIJJKKLLMMNNOOPPQQRRSSTTTUUVVWWXXYYZZ[[[\\\\]]^^__```aabbcccddeefffgghhhiijjjkklllmmnnnoopppqqqrrssstttuuvvvwwwxxxyyyzzz{{{|||}}}~~~\7F\7F\7F\80\80", align 1
@_ZN5rally3r18L13HeadingAnglesE = internal unnamed_addr constant [289 x i16] [i16 0, i16 81, i16 163, i16 244, i16 326, i16 408, i16 489, i16 571, i16 652, i16 734, i16 816, i16 897, i16 979, i16 1061, i16 1143, i16 1225, i16 1307, i16 1389, i16 1472, i16 1554, i16 1636, i16 1719, i16 1802, i16 1884, i16 1967, i16 2050, i16 2134, i16 2217, i16 2300, i16 2384, i16 2468, i16 2551, i16 2636, i16 2720, i16 2804, i16 2889, i16 2974, i16 3059, i16 3144, i16 3229, i16 3315, i16 3401, i16 3487, i16 3573, i16 3660, i16 3747, i16 3834, i16 3922, i16 4009, i16 4097, i16 4186, i16 4275, i16 4364, i16 4453, i16 4543, i16 4633, i16 4723, i16 4814, i16 4905, i16 4997, i16 5089, i16 5181, i16 5274, i16 5367, i16 5461, i16 5556, i16 5651, i16 5746, i16 5842, i16 5938, i16 6035, i16 6133, i16 6231, i16 6330, i16 6430, i16 6530, i16 6631, i16 6732, i16 6835, i16 6938, i16 7042, i16 7147, i16 7252, i16 7359, i16 7466, i16 7575, i16 7684, i16 7795, i16 7907, i16 8019, i16 8133, i16 8249, i16 8365, i16 8483, i16 8602, i16 8723, i16 8846, i16 8970, i16 9095, i16 9223, i16 9353, i16 9484, i16 9618, i16 9754, i16 9892, i16 10034, i16 10177, i16 10324, i16 10475, i16 10628, i16 10785, i16 10947, i16 11113, i16 11155, i16 11198, i16 11241, i16 11284, i16 11327, i16 11371, i16 11415, i16 11460, i16 11505, i16 11550, i16 11596, i16 11642, i16 11689, i16 11736, i16 11784, i16 11831, i16 11880, i16 11929, i16 11978, i16 12028, i16 12079, i16 12130, i16 12181, i16 12234, i16 12287, i16 12340, i16 12394, i16 12449, i16 12505, i16 12561, i16 12619, i16 12677, i16 12736, i16 12796, i16 12857, i16 12919, i16 12982, i16 13046, i16 13111, i16 13178, i16 13246, i16 13315, i16 13386, i16 13459, i16 13534, i16 13610, i16 13689, i16 13770, i16 13780, i16 13790, i16 13801, i16 13811, i16 13821, i16 13832, i16 13842, i16 13853, i16 13864, i16 13874, i16 13885, i16 13896, i16 13907, i16 13917, i16 13928, i16 13939, i16 13950, i16 13961, i16 13972, i16 13983, i16 13995, i16 14006, i16 14017, i16 14029, i16 14040, i16 14051, i16 14063, i16 14074, i16 14086, i16 14098, i16 14110, i16 14121, i16 14133, i16 14145, i16 14157, i16 14169, i16 14181, i16 14193, i16 14206, i16 14218, i16 14230, i16 14243, i16 14255, i16 14268, i16 14281, i16 14293, i16 14306, i16 14319, i16 14332, i16 14345, i16 14358, i16 14372, i16 14385, i16 14398, i16 14412, i16 14425, i16 14439, i16 14453, i16 14467, i16 14481, i16 14495, i16 14509, i16 14523, i16 14538, i16 14552, i16 14567, i16 14582, i16 14597, i16 14612, i16 14627, i16 14642, i16 14657, i16 14673, i16 14688, i16 14704, i16 14720, i16 14736, i16 14753, i16 14769, i16 14786, i16 14802, i16 14819, i16 14836, i16 14854, i16 14871, i16 14889, i16 14907, i16 14925, i16 14944, i16 14962, i16 14981, i16 15000, i16 15019, i16 15039, i16 15059, i16 15079, i16 15100, i16 15121, i16 15142, i16 15164, i16 15186, i16 15208, i16 15231, i16 15254, i16 15278, i16 15302, i16 15327, i16 15353, i16 15379, i16 15406, i16 15433, i16 15462, i16 15491, i16 15521, i16 15553, i16 15585, i16 15619, i16 15655, i16 15692, i16 15732, i16 15774, i16 15819, i16 15869, i16 15923, i16 15985, i16 16058, i16 16154, i16 16384], align 1
@_ZN5rally3r18L13BearingAnglesE = internal unnamed_addr constant [257 x i16] [i16 0, i16 130, i16 261, i16 391, i16 521, i16 651, i16 781, i16 910, i16 1040, i16 1169, i16 1297, i16 1425, i16 1553, i16 1680, i16 1807, i16 1933, i16 2059, i16 2184, i16 2308, i16 2432, i16 2555, i16 2678, i16 2799, i16 2920, i16 3040, i16 3159, i16 3278, i16 3395, i16 3512, i16 3627, i16 3742, i16 3856, i16 3969, i16 4081, i16 4192, i16 4302, i16 4411, i16 4518, i16 4625, i16 4731, i16 4836, i16 4940, i16 5043, i16 5144, i16 5245, i16 5344, i16 5443, i16 5540, i16 5637, i16 5732, i16 5826, i16 5920, i16 6012, i16 6103, i16 6193, i16 6282, i16 6370, i16 6457, i16 6543, i16 6628, i16 6712, i16 6795, i16 6877, i16 6958, i16 7038, i16 7117, i16 7195, i16 7272, i16 7348, i16 7423, i16 7498, i16 7571, i16 7644, i16 7715, i16 7786, i16 7856, i16 7925, i16 7993, i16 8060, i16 8126, i16 8192, i16 8257, i16 8321, i16 8384, i16 8446, i16 8508, i16 8569, i16 8629, i16 8688, i16 8747, i16 8805, i16 8862, i16 8919, i16 8974, i16 9029, i16 9084, i16 9138, i16 9191, i16 9243, i16 9295, i16 9346, i16 9397, i16 9447, i16 9496, i16 9545, i16 9593, i16 9641, i16 9688, i16 9734, i16 9780, i16 9825, i16 9870, i16 9915, i16 9958, i16 10002, i16 10044, i16 10087, i16 10128, i16 10170, i16 10211, i16 10251, i16 10291, i16 10330, i16 10369, i16 10408, i16 10446, i16 10484, i16 10521, i16 10558, i16 10594, i16 10630, i16 10666, i16 10701, i16 10736, i16 10770, i16 10804, i16 10838, i16 10871, i16 10904, i16 10937, i16 10969, i16 11001, i16 11033, i16 11064, i16 11095, i16 11125, i16 11156, i16 11186, i16 11215, i16 11245, i16 11274, i16 11302, i16 11331, i16 11359, i16 11387, i16 11414, i16 11442, i16 11469, i16 11495, i16 11522, i16 11548, i16 11574, i16 11600, i16 11625, i16 11650, i16 11675, i16 11700, i16 11724, i16 11749, i16 11773, i16 11796, i16 11820, i16 11843, i16 11866, i16 11889, i16 11912, i16 11934, i16 11956, i16 11978, i16 12000, i16 12022, i16 12043, i16 12064, i16 12085, i16 12106, i16 12127, i16 12147, i16 12168, i16 12188, i16 12208, i16 12227, i16 12247, i16 12266, i16 12285, i16 12304, i16 12323, i16 12342, i16 12361, i16 12379, i16 12397, i16 12415, i16 12433, i16 12451, i16 12468, i16 12486, i16 12503, i16 12520, i16 12537, i16 12554, i16 12571, i16 12588, i16 12604, i16 12620, i16 12637, i16 12653, i16 12668, i16 12684, i16 12700, i16 12715, i16 12731, i16 12746, i16 12761, i16 12776, i16 12791, i16 12806, i16 12821, i16 12835, i16 12850, i16 12864, i16 12878, i16 12893, i16 12907, i16 12920, i16 12934, i16 12948, i16 12962, i16 12975, i16 12988, i16 13002, i16 13015, i16 13028, i16 13041, i16 13054, i16 13067, i16 13079, i16 13092, i16 13105, i16 13117, i16 13129, i16 13142, i16 13154, i16 13166, i16 13178, i16 13190, i16 13201, i16 13213, i16 13225], align 1
@llvm.global_ctors = appending global [0 x { i32, ptr, ptr }] zeroinitializer
@str = private unnamed_addr constant [65 x i8] c"Usage: rally [oval|fuji] [circuit|arcade] [steer1|steer2] [mute]\00", align 1
@switch.table._ZN12_GLOBAL__N_112phaseChangedEv = private unnamed_addr constant [9 x i8] c"\01\09\09\09\09\09\07\08\09", align 1

; Function Attrs: minsize nounwind optsize
define dso_local noundef i24 @_Z8gameMainiPPc(i24 noundef %0, ptr nocapture noundef readonly %1) local_unnamed_addr #0 {
  %3 = alloca [40 x i8], align 1
  %4 = alloca %"struct.rally::game::HudImage", align 1
  %5 = alloca [48 x i8], align 1
  %6 = alloca [20 x i8], align 1
  %7 = alloca [160 x i8], align 1
  %8 = alloca [20 x i8], align 1
  %9 = alloca [6 x i32], align 1
  %10 = alloca [6 x i16], align 1
  %11 = alloca [32 x i8], align 1
  %12 = alloca [6 x i8], align 1
  %13 = alloca %"struct.rally::Stream", align 1
  %14 = alloca [34 x i8], align 1
  %15 = alloca [6 x i8], align 1
  store i24 200, ptr getelementptr inbounds (%"struct.rally::Motion", ptr @_ZN12_GLOBAL__N_16motionE, i24 0, i32 8), align 1, !tbaa !2
  %16 = tail call i24 @llvm.smax.i24(i24 %0, i24 1)
  br label %17

17:                                               ; preds = %60, %2
  %18 = phi i24 [ 1, %2 ], [ %61, %60 ]
  %19 = icmp eq i24 %18, %16
  br i1 %19, label %64, label %20

20:                                               ; preds = %17
  %21 = getelementptr inbounds ptr, ptr %1, i24 %18
  %22 = load ptr, ptr %21, align 1, !tbaa !11
  %23 = tail call i24 @strcmp(ptr noundef %22, ptr noundef nonnull @.str) #17
  %24 = icmp eq i24 %23, 0
  br i1 %24, label %25, label %26

25:                                               ; preds = %20
  store ptr @_ZN5rallyL7TriOvalE, ptr @_ZN12_GLOBAL__N_18selectedE, align 1, !tbaa !11
  br label %60

26:                                               ; preds = %20
  %27 = load ptr, ptr %21, align 1, !tbaa !11
  %28 = tail call i24 @strcmp(ptr noundef %27, ptr noundef nonnull @.str.3) #17
  %29 = icmp eq i24 %28, 0
  br i1 %29, label %30, label %31

30:                                               ; preds = %26
  store ptr @_ZN5rallyL4FujiE, ptr @_ZN12_GLOBAL__N_18selectedE, align 1, !tbaa !11
  br label %60

31:                                               ; preds = %26
  %32 = load ptr, ptr %21, align 1, !tbaa !11
  %33 = tail call i24 @strcmp(ptr noundef %32, ptr noundef nonnull @.str.4) #17
  %34 = icmp eq i24 %33, 0
  br i1 %34, label %35, label %36

35:                                               ; preds = %31
  store i8 1, ptr @_ZN12_GLOBAL__N_15mutedE, align 1, !tbaa !12
  br label %60

36:                                               ; preds = %31
  %37 = load ptr, ptr %21, align 1, !tbaa !11
  %38 = tail call i24 @strcmp(ptr noundef %37, ptr noundef nonnull @.str.5) #17
  %39 = icmp eq i24 %38, 0
  br i1 %39, label %40, label %41

40:                                               ; preds = %36
  store i1 true, ptr @_ZN12_GLOBAL__N_112steeringStepE, align 1
  br label %60

41:                                               ; preds = %36
  %42 = load ptr, ptr %21, align 1, !tbaa !11
  %43 = tail call i24 @strcmp(ptr noundef %42, ptr noundef nonnull @.str.6) #17
  %44 = icmp eq i24 %43, 0
  br i1 %44, label %45, label %46

45:                                               ; preds = %41
  store i1 false, ptr @_ZN12_GLOBAL__N_112steeringStepE, align 1
  br label %60

46:                                               ; preds = %41
  %47 = load ptr, ptr %21, align 1, !tbaa !11
  %48 = tail call i24 @strcmp(ptr noundef %47, ptr noundef nonnull @.str.7) #17
  %49 = icmp eq i24 %48, 0
  br i1 %49, label %50, label %51

50:                                               ; preds = %46
  store i8 1, ptr getelementptr inbounds (%"struct.rally::game::Rules", ptr @_ZN12_GLOBAL__N_15rulesE, i24 0, i32 1), align 1, !tbaa !13
  br label %60

51:                                               ; preds = %46
  %52 = load ptr, ptr %21, align 1, !tbaa !11
  %53 = tail call i24 @strcmp(ptr noundef %52, ptr noundef nonnull @.str.8) #17
  %54 = icmp eq i24 %53, 0
  br i1 %54, label %55, label %56

55:                                               ; preds = %51
  store i8 0, ptr getelementptr inbounds (%"struct.rally::game::Rules", ptr @_ZN12_GLOBAL__N_15rulesE, i24 0, i32 1), align 1, !tbaa !13
  br label %60

56:                                               ; preds = %51
  %57 = load ptr, ptr %21, align 1, !tbaa !11
  %58 = tail call i24 @strcmp(ptr noundef %57, ptr noundef nonnull @.str.9) #17
  %59 = icmp eq i24 %58, 0
  br i1 %59, label %60, label %62

60:                                               ; preds = %25, %35, %45, %55, %56, %50, %40, %30
  %61 = add nuw i24 %18, 1
  br label %17, !llvm.loop !18

62:                                               ; preds = %56
  %63 = tail call i24 @puts(ptr nonnull @str)
  br label %988

64:                                               ; preds = %17
  %65 = tail call noundef i1 @_ZN5rally4game11readRecordsEPKcRNS0_7RecordsE(ptr noundef nonnull @.str.11, ptr noundef nonnull align 1 dereferenceable(2304) @_ZN12_GLOBAL__N_17recordsE) #18
  br i1 %65, label %68, label %66

66:                                               ; preds = %64
  %67 = tail call noundef i1 @_ZN5rally4game11readRecordsEPKcRNS0_7RecordsE(ptr noundef nonnull @.str.12, ptr noundef nonnull align 1 dereferenceable(2304) @_ZN12_GLOBAL__N_17recordsE) #18
  br label %68

68:                                               ; preds = %66, %64
  tail call fastcc void @_ZN12_GLOBAL__N_19loadTrackEv() #18
  %69 = tail call i24 @vdp_mode(i24 noundef 136) #17
  %70 = icmp slt i24 %69, 0
  br i1 %70, label %988, label %71

71:                                               ; preds = %68
  tail call void @vdp_set_pixel_coordinates() #17
  tail call void @vdp_reset_sprites() #17
  tail call void @vdp_cursor_enable(i1 noundef false) #17
  br label %72

72:                                               ; preds = %90, %71
  %73 = phi i24 [ 0, %71 ], [ %91, %90 ]
  %74 = icmp eq i24 %73, 5
  br i1 %74, label %75, label %80

75:                                               ; preds = %72
  %76 = getelementptr inbounds %"struct.rally::Stream", ptr %13, i24 0, i32 1
  %77 = getelementptr inbounds %"struct.rally::Stream", ptr %13, i24 0, i32 2
  %78 = getelementptr inbounds [4096 x i8], ptr %13, i24 0, i24 1
  %79 = getelementptr inbounds [4096 x i8], ptr %13, i24 0, i24 2
  br label %108

80:                                               ; preds = %72
  %81 = add nuw nsw i24 %73, 64000
  tail call void @vdp_adv_clear_buffer(i24 noundef %81) #17
  br label %82

82:                                               ; preds = %95, %80
  %83 = phi i24 [ 0, %80 ], [ %96, %95 ]
  %84 = icmp eq i24 %83, 77
  br i1 %84, label %90, label %85

85:                                               ; preds = %82
  %86 = mul nuw nsw i24 %83, 48
  %87 = udiv i24 %86, 77
  %88 = shl nuw nsw i24 %87, 6
  %89 = mul nuw nsw i24 %83, 102
  br label %92

90:                                               ; preds = %82
  tail call void @vdp_adv_write_block_data(i24 noundef %81, i24 noundef 7854, ptr noundef nonnull @_ZN12_GLOBAL__N_19carUploadE) #17
  tail call void @vdp_select_bitmap(i24 noundef %73) #17
  tail call void @vdp_adv_bitmap_from_buffer(i24 noundef 102, i24 noundef 77, i24 noundef 1) #17
  %91 = add nuw nsw i24 %73, 1
  br label %72, !llvm.loop !20

92:                                               ; preds = %97, %85
  %93 = phi i24 [ %107, %97 ], [ 0, %85 ]
  %94 = icmp eq i24 %93, 102
  br i1 %94, label %95, label %97

95:                                               ; preds = %92
  %96 = add nuw nsw i24 %83, 1
  br label %82, !llvm.loop !21

97:                                               ; preds = %92
  %98 = trunc i24 %93 to i16
  %99 = shl i16 %98, 6
  %100 = udiv i16 %99, 102
  %101 = zext i16 %100 to i24
  %102 = add nuw i24 %88, %101
  %103 = getelementptr inbounds [5 x [3072 x i8]], ptr @_ZN5rallyL9CarPixelsE, i24 0, i24 %73, i24 %102
  %104 = load i8, ptr %103, align 1, !tbaa !22
  %105 = add nuw nsw i24 %93, %89
  %106 = getelementptr inbounds [7854 x i8], ptr @_ZN12_GLOBAL__N_19carUploadE, i24 0, i24 %105
  store i8 %104, ptr %106, align 1, !tbaa !22
  %107 = add nuw nsw i24 %93, 1
  br label %92, !llvm.loop !23

108:                                              ; preds = %167, %75
  %109 = phi i24 [ %168, %167 ], [ 1, %75 ]
  %110 = icmp eq i24 %109, 7
  br i1 %110, label %111, label %154

111:                                              ; preds = %108
  call void @vdp_adv_clear_buffer(i24 noundef 63960) #17
  call void @llvm.lifetime.start.p0(i64 34, ptr nonnull %14) #19
  call void @llvm.memcpy.p0.p0.i24(ptr noundef nonnull align 1 dereferenceable(34) %14, ptr noundef nonnull align 1 dereferenceable(34) @__const._ZN12_GLOBAL__N_18loadCarsEv.mirrorCommands, i24 34, i1 false)
  call void @mos_puts(ptr noundef nonnull %14, i24 noundef 34, i8 noundef 0) #17
  call void @vdp_adv_clear_buffer(i24 noundef 63800) #17
  call void @vdp_adv_write_block_data(i24 noundef 63800, i24 noundef 53248, ptr noundef nonnull @_ZN5rallyL13SceneryPixelsE) #17
  call void @vdp_adv_clear_buffer(i24 noundef 64100) #17
  %112 = load i24, ptr getelementptr inbounds (%"struct.rally::Stream", ptr @_ZN12_GLOBAL__N_16streamE, i24 0, i32 1), align 1, !tbaa !24
  %113 = icmp ult i24 %112, 4096
  br i1 %113, label %114, label %127

114:                                              ; preds = %111
  %115 = add nuw nsw i24 %112, 1
  store i24 %115, ptr getelementptr inbounds (%"struct.rally::Stream", ptr @_ZN12_GLOBAL__N_16streamE, i24 0, i32 1), align 1, !tbaa !24
  %116 = getelementptr inbounds [4096 x i8], ptr @_ZN12_GLOBAL__N_16streamE, i24 0, i24 %112
  store i8 23, ptr %116, align 1, !tbaa !22
  %117 = load i24, ptr getelementptr inbounds (%"struct.rally::Stream", ptr @_ZN12_GLOBAL__N_16streamE, i24 0, i32 1), align 1, !tbaa !24
  %118 = icmp ult i24 %117, 4096
  br i1 %118, label %119, label %127

119:                                              ; preds = %114
  %120 = add nuw nsw i24 %117, 1
  store i24 %120, ptr getelementptr inbounds (%"struct.rally::Stream", ptr @_ZN12_GLOBAL__N_16streamE, i24 0, i32 1), align 1, !tbaa !24
  %121 = getelementptr inbounds [4096 x i8], ptr @_ZN12_GLOBAL__N_16streamE, i24 0, i24 %117
  store i8 0, ptr %121, align 1, !tbaa !22
  %122 = load i24, ptr getelementptr inbounds (%"struct.rally::Stream", ptr @_ZN12_GLOBAL__N_16streamE, i24 0, i32 1), align 1, !tbaa !24
  %123 = icmp ult i24 %122, 4096
  br i1 %123, label %124, label %127

124:                                              ; preds = %119
  %125 = add nuw nsw i24 %122, 1
  store i24 %125, ptr getelementptr inbounds (%"struct.rally::Stream", ptr @_ZN12_GLOBAL__N_16streamE, i24 0, i32 1), align 1, !tbaa !24
  %126 = getelementptr inbounds [4096 x i8], ptr @_ZN12_GLOBAL__N_16streamE, i24 0, i24 %122
  store i8 -96, ptr %126, align 1, !tbaa !22
  br label %128

127:                                              ; preds = %119, %114, %111
  store i8 1, ptr getelementptr inbounds (%"struct.rally::Stream", ptr @_ZN12_GLOBAL__N_16streamE, i24 0, i32 2), align 1, !tbaa !26
  br label %128

128:                                              ; preds = %127, %124
  call void @_ZN5rally6Stream4wordEi(ptr noundef nonnull align 1 dereferenceable(4100) @_ZN12_GLOBAL__N_16streamE, i24 noundef 64100) #18
  %129 = load i24, ptr getelementptr inbounds (%"struct.rally::Stream", ptr @_ZN12_GLOBAL__N_16streamE, i24 0, i32 1), align 1, !tbaa !24
  %130 = icmp ult i24 %129, 4096
  br i1 %130, label %131, label %139

131:                                              ; preds = %128
  %132 = add nuw nsw i24 %129, 1
  store i24 %132, ptr getelementptr inbounds (%"struct.rally::Stream", ptr @_ZN12_GLOBAL__N_16streamE, i24 0, i32 1), align 1, !tbaa !24
  %133 = getelementptr inbounds [4096 x i8], ptr @_ZN12_GLOBAL__N_16streamE, i24 0, i24 %129
  store i8 72, ptr %133, align 1, !tbaa !22
  %134 = load i24, ptr getelementptr inbounds (%"struct.rally::Stream", ptr @_ZN12_GLOBAL__N_16streamE, i24 0, i32 1), align 1, !tbaa !24
  %135 = icmp ult i24 %134, 4096
  br i1 %135, label %136, label %139

136:                                              ; preds = %131
  %137 = add nuw nsw i24 %134, 1
  store i24 %137, ptr getelementptr inbounds (%"struct.rally::Stream", ptr @_ZN12_GLOBAL__N_16streamE, i24 0, i32 1), align 1, !tbaa !24
  %138 = getelementptr inbounds [4096 x i8], ptr @_ZN12_GLOBAL__N_16streamE, i24 0, i24 %134
  store i8 4, ptr %138, align 1, !tbaa !22
  br label %140

139:                                              ; preds = %131, %128
  store i8 1, ptr getelementptr inbounds (%"struct.rally::Stream", ptr @_ZN12_GLOBAL__N_16streamE, i24 0, i32 2), align 1, !tbaa !26
  br label %140

140:                                              ; preds = %139, %136
  call void @_ZN5rally6Stream4wordEi(ptr noundef nonnull align 1 dereferenceable(4100) @_ZN12_GLOBAL__N_16streamE, i24 noundef 63800) #18
  br label %141

141:                                              ; preds = %152, %140
  %142 = phi ptr [ @_ZN5rallyL14SceneryPaletteE, %140 ], [ %153, %152 ]
  %143 = icmp eq ptr %142, getelementptr inbounds ([16 x i8], ptr @_ZN5rallyL14SceneryPaletteE, i24 1, i24 0)
  br i1 %143, label %187, label %144

144:                                              ; preds = %141
  %145 = load i24, ptr getelementptr inbounds (%"struct.rally::Stream", ptr @_ZN12_GLOBAL__N_16streamE, i24 0, i32 1), align 1, !tbaa !24
  %146 = icmp ult i24 %145, 4096
  br i1 %146, label %147, label %151

147:                                              ; preds = %144
  %148 = load i8, ptr %142, align 1, !tbaa !22
  %149 = add nuw nsw i24 %145, 1
  store i24 %149, ptr getelementptr inbounds (%"struct.rally::Stream", ptr @_ZN12_GLOBAL__N_16streamE, i24 0, i32 1), align 1, !tbaa !24
  %150 = getelementptr inbounds [4096 x i8], ptr @_ZN12_GLOBAL__N_16streamE, i24 0, i24 %145
  store i8 %148, ptr %150, align 1, !tbaa !22
  br label %152

151:                                              ; preds = %144
  store i8 1, ptr getelementptr inbounds (%"struct.rally::Stream", ptr @_ZN12_GLOBAL__N_16streamE, i24 0, i32 2), align 1, !tbaa !26
  br label %152

152:                                              ; preds = %151, %147
  %153 = getelementptr inbounds i8, ptr %142, i24 1
  br label %141

154:                                              ; preds = %108, %159
  %155 = phi i24 [ %163, %159 ], [ 0, %108 ]
  %156 = icmp eq i24 %155, 256
  br i1 %156, label %157, label %159

157:                                              ; preds = %154
  call void @vdp_adv_clear_buffer(i24 noundef 63960) #17
  call void @vdp_adv_write_block_data(i24 noundef 63960, i24 noundef 256, ptr noundef nonnull @_ZN12_GLOBAL__N_19carUploadE) #17
  %158 = mul nuw nsw i24 %109, 5
  br label %164

159:                                              ; preds = %154
  %160 = trunc i24 %155 to i8
  %161 = call noundef i8 @_ZN5rally9carColourEhj(i8 noundef %160, i24 noundef %109) #18
  %162 = getelementptr inbounds [7854 x i8], ptr @_ZN12_GLOBAL__N_19carUploadE, i24 0, i24 %155
  store i8 %161, ptr %162, align 1, !tbaa !22
  %163 = add nuw nsw i24 %155, 1
  br label %154, !llvm.loop !27

164:                                              ; preds = %183, %157
  %165 = phi i24 [ 0, %157 ], [ %186, %183 ]
  %166 = icmp eq i24 %165, 5
  br i1 %166, label %167, label %169

167:                                              ; preds = %164
  %168 = add nuw nsw i24 %109, 1
  br label %108, !llvm.loop !28

169:                                              ; preds = %164
  %170 = add nuw nsw i24 %165, %158
  %171 = add nuw nsw i24 %170, 64000
  call void @vdp_adv_clear_buffer(i24 noundef %171) #17
  call void @llvm.lifetime.start.p0(i64 4100, ptr nonnull %13) #19
  store i8 0, ptr %77, align 1, !tbaa !26
  store i8 23, ptr %13, align 1, !tbaa !22
  store i8 0, ptr %78, align 1, !tbaa !22
  store i24 3, ptr %76, align 1, !tbaa !24
  store i8 -96, ptr %79, align 1, !tbaa !22
  call void @_ZN5rally6Stream4wordEi(ptr noundef nonnull align 1 dereferenceable(4100) %13, i24 noundef %171) #18
  %172 = load i24, ptr %76, align 1, !tbaa !24
  %173 = icmp ult i24 %172, 4096
  br i1 %173, label %174, label %182

174:                                              ; preds = %169
  %175 = add nuw nsw i24 %172, 1
  store i24 %175, ptr %76, align 1, !tbaa !24
  %176 = getelementptr inbounds [4096 x i8], ptr %13, i24 0, i24 %172
  store i8 72, ptr %176, align 1, !tbaa !22
  %177 = load i24, ptr %76, align 1, !tbaa !24
  %178 = icmp ult i24 %177, 4096
  br i1 %178, label %179, label %182

179:                                              ; preds = %174
  %180 = add nuw nsw i24 %177, 1
  store i24 %180, ptr %76, align 1, !tbaa !24
  %181 = getelementptr inbounds [4096 x i8], ptr %13, i24 0, i24 %177
  store i8 16, ptr %181, align 1, !tbaa !22
  br label %183

182:                                              ; preds = %174, %169
  store i8 1, ptr %77, align 1, !tbaa !26
  br label %183

183:                                              ; preds = %182, %179
  %184 = add nuw nsw i24 %165, 64000
  call void @_ZN5rally6Stream4wordEi(ptr noundef nonnull align 1 dereferenceable(4100) %13, i24 noundef %184) #18
  call void @_ZN5rally6Stream4wordEi(ptr noundef nonnull align 1 dereferenceable(4100) %13, i24 noundef 63960) #18
  %185 = load i24, ptr %76, align 1, !tbaa !24
  call void @mos_puts(ptr noundef nonnull %13, i24 noundef %185, i8 noundef 0) #17
  call void @vdp_select_bitmap(i24 noundef %170) #17
  call void @vdp_adv_bitmap_from_buffer(i24 noundef 102, i24 noundef 77, i24 noundef 1) #17
  call void @llvm.lifetime.end.p0(i64 4100, ptr nonnull %13) #19
  %186 = add nuw nsw i24 %165, 1
  br label %164, !llvm.loop !29

187:                                              ; preds = %141
  call fastcc void @_ZN12_GLOBAL__N_15flushEv() #18
  call void @vdp_select_bitmap(i24 noundef 100) #17
  call void @vdp_adv_bitmap_from_buffer(i24 noundef 1024, i24 noundef 104, i24 noundef 1) #17
  call void @vdp_adv_clear_buffer(i24 noundef 63800) #17
  call void @vdp_set_text_colour(i24 noundef 15) #17
  call void @vdp_set_text_bg_colour(i24 noundef 0) #17
  call void @llvm.lifetime.end.p0(i64 34, ptr nonnull %14) #19
  call void @vdp_adv_clear_buffer(i24 noundef 63940) #17
  call void @vdp_adv_write_block_data(i24 noundef 63940, i24 noundef 2048, ptr noundef nonnull @_ZN5rally4gameL10FontPixelsE) #17
  call fastcc void @_ZN12_GLOBAL__N_110fontCreateEjj(i24 noundef 63940, i24 noundef 8) #18
  call void @vdp_adv_clear_buffer(i24 noundef 63941) #17
  br label %188

188:                                              ; preds = %201, %187
  %189 = phi i24 [ 0, %187 ], [ %202, %201 ]
  %190 = icmp eq i24 %189, 256
  br i1 %190, label %228, label %191

191:                                              ; preds = %188
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %11) #19
  %192 = shl i24 %189, 3
  br label %193

193:                                              ; preds = %207, %191
  %194 = phi i24 [ 0, %191 ], [ %219, %207 ]
  %195 = icmp eq i24 %194, 8
  br i1 %195, label %201, label %196

196:                                              ; preds = %193
  %197 = add nuw nsw i24 %194, %192
  %198 = getelementptr inbounds [2048 x i8], ptr @_ZN5rally4gameL10FontPixelsE, i24 0, i24 %197
  %199 = load i8, ptr %198, align 1, !tbaa !22
  %200 = zext i8 %199 to i24
  br label %203

201:                                              ; preds = %193
  call void @vdp_adv_write_block_data(i24 noundef 63941, i24 noundef 32, ptr noundef nonnull %11) #17
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %11) #19
  %202 = add nuw nsw i24 %189, 1
  br label %188, !llvm.loop !30

203:                                              ; preds = %220, %196
  %204 = phi i24 [ %226, %220 ], [ 0, %196 ]
  %205 = phi i24 [ %227, %220 ], [ 0, %196 ]
  %206 = icmp eq i24 %205, 8
  br i1 %206, label %207, label %220

207:                                              ; preds = %203
  %208 = lshr i24 %204, 8
  %209 = trunc i24 %208 to i8
  %210 = shl i24 %194, 2
  %211 = or i24 %210, 2
  %212 = getelementptr inbounds [32 x i8], ptr %11, i24 0, i24 %211
  store i8 %209, ptr %212, align 1, !tbaa !22
  %213 = getelementptr inbounds [32 x i8], ptr %11, i24 0, i24 %210
  store i8 %209, ptr %213, align 1, !tbaa !22
  %214 = trunc i24 %204 to i8
  %215 = or i24 %210, 3
  %216 = getelementptr inbounds [32 x i8], ptr %11, i24 0, i24 %215
  store i8 %214, ptr %216, align 1, !tbaa !22
  %217 = or i24 %210, 1
  %218 = getelementptr inbounds [32 x i8], ptr %11, i24 0, i24 %217
  store i8 %214, ptr %218, align 1, !tbaa !22
  %219 = add nuw nsw i24 %194, 1
  br label %193, !llvm.loop !31

220:                                              ; preds = %203
  %221 = shl i24 %204, 2
  %222 = lshr i24 128, %205
  %223 = and i24 %222, %200
  %224 = icmp eq i24 %223, 0
  %225 = select i1 %224, i24 0, i24 3
  %226 = or i24 %225, %221
  %227 = add nuw nsw i24 %205, 1
  br label %203, !llvm.loop !32

228:                                              ; preds = %188
  call void @llvm.lifetime.start.p0(i64 6, ptr nonnull %12) #19
  call void @llvm.memcpy.p0.p0.i24(ptr noundef nonnull align 1 dereferenceable(6) %12, ptr noundef nonnull align 1 dereferenceable(6) @__const._ZN12_GLOBAL__N_18loadFontEv.consolidate, i24 6, i1 false)
  call void @_ZN12_GLOBAL__N_14sendEPKhj(ptr noundef nonnull %12, i24 noundef 6) #18
  call fastcc void @_ZN12_GLOBAL__N_110fontCreateEjj(i24 noundef 63941, i24 noundef 16) #18
  call fastcc void @_ZN12_GLOBAL__N_14fontEj(i24 noundef 63940) #18
  call void @llvm.lifetime.end.p0(i64 6, ptr nonnull %12) #19
  br label %229

229:                                              ; preds = %269, %228
  %230 = phi i24 [ 0, %228 ], [ %270, %269 ]
  %231 = icmp eq i24 %230, 8
  br i1 %231, label %282, label %232

232:                                              ; preds = %229
  %233 = getelementptr inbounds [8 x %"struct.rally::game::SignArt"], ptr @_ZN5rally4gameL11SignArtworkE, i24 0, i24 %230
  %234 = add nuw nsw i24 %230, 120
  call void @vdp_adv_clear_buffer(i24 noundef 63800) #17
  %235 = getelementptr inbounds [8 x %"struct.rally::game::SignArt"], ptr @_ZN5rally4gameL11SignArtworkE, i24 0, i24 %230, i32 1
  call void @vdp_adv_write_block_data(i24 noundef 63800, i24 noundef 2048, ptr noundef nonnull %235) #17
  %236 = add nuw nsw i24 %230, 64120
  call void @vdp_adv_clear_buffer(i24 noundef %236) #17
  %237 = load i24, ptr getelementptr inbounds (%"struct.rally::Stream", ptr @_ZN12_GLOBAL__N_16streamE, i24 0, i32 1), align 1, !tbaa !24
  %238 = icmp ult i24 %237, 4096
  br i1 %238, label %239, label %252

239:                                              ; preds = %232
  %240 = add nuw nsw i24 %237, 1
  store i24 %240, ptr getelementptr inbounds (%"struct.rally::Stream", ptr @_ZN12_GLOBAL__N_16streamE, i24 0, i32 1), align 1, !tbaa !24
  %241 = getelementptr inbounds [4096 x i8], ptr @_ZN12_GLOBAL__N_16streamE, i24 0, i24 %237
  store i8 23, ptr %241, align 1, !tbaa !22
  %242 = load i24, ptr getelementptr inbounds (%"struct.rally::Stream", ptr @_ZN12_GLOBAL__N_16streamE, i24 0, i32 1), align 1, !tbaa !24
  %243 = icmp ult i24 %242, 4096
  br i1 %243, label %244, label %252

244:                                              ; preds = %239
  %245 = add nuw nsw i24 %242, 1
  store i24 %245, ptr getelementptr inbounds (%"struct.rally::Stream", ptr @_ZN12_GLOBAL__N_16streamE, i24 0, i32 1), align 1, !tbaa !24
  %246 = getelementptr inbounds [4096 x i8], ptr @_ZN12_GLOBAL__N_16streamE, i24 0, i24 %242
  store i8 0, ptr %246, align 1, !tbaa !22
  %247 = load i24, ptr getelementptr inbounds (%"struct.rally::Stream", ptr @_ZN12_GLOBAL__N_16streamE, i24 0, i32 1), align 1, !tbaa !24
  %248 = icmp ult i24 %247, 4096
  br i1 %248, label %249, label %252

249:                                              ; preds = %244
  %250 = add nuw nsw i24 %247, 1
  store i24 %250, ptr getelementptr inbounds (%"struct.rally::Stream", ptr @_ZN12_GLOBAL__N_16streamE, i24 0, i32 1), align 1, !tbaa !24
  %251 = getelementptr inbounds [4096 x i8], ptr @_ZN12_GLOBAL__N_16streamE, i24 0, i24 %247
  store i8 -96, ptr %251, align 1, !tbaa !22
  br label %253

252:                                              ; preds = %244, %239, %232
  store i8 1, ptr getelementptr inbounds (%"struct.rally::Stream", ptr @_ZN12_GLOBAL__N_16streamE, i24 0, i32 2), align 1, !tbaa !26
  br label %253

253:                                              ; preds = %252, %249
  call void @_ZN5rally6Stream4wordEi(ptr noundef nonnull align 1 dereferenceable(4100) @_ZN12_GLOBAL__N_16streamE, i24 noundef %236) #18
  %254 = load i24, ptr getelementptr inbounds (%"struct.rally::Stream", ptr @_ZN12_GLOBAL__N_16streamE, i24 0, i32 1), align 1, !tbaa !24
  %255 = icmp ult i24 %254, 4096
  br i1 %255, label %256, label %264

256:                                              ; preds = %253
  %257 = add nuw nsw i24 %254, 1
  store i24 %257, ptr getelementptr inbounds (%"struct.rally::Stream", ptr @_ZN12_GLOBAL__N_16streamE, i24 0, i32 1), align 1, !tbaa !24
  %258 = getelementptr inbounds [4096 x i8], ptr @_ZN12_GLOBAL__N_16streamE, i24 0, i24 %254
  store i8 72, ptr %258, align 1, !tbaa !22
  %259 = load i24, ptr getelementptr inbounds (%"struct.rally::Stream", ptr @_ZN12_GLOBAL__N_16streamE, i24 0, i32 1), align 1, !tbaa !24
  %260 = icmp ult i24 %259, 4096
  br i1 %260, label %261, label %264

261:                                              ; preds = %256
  %262 = add nuw nsw i24 %259, 1
  store i24 %262, ptr getelementptr inbounds (%"struct.rally::Stream", ptr @_ZN12_GLOBAL__N_16streamE, i24 0, i32 1), align 1, !tbaa !24
  %263 = getelementptr inbounds [4096 x i8], ptr @_ZN12_GLOBAL__N_16streamE, i24 0, i24 %259
  store i8 4, ptr %263, align 1, !tbaa !22
  br label %265

264:                                              ; preds = %256, %253
  store i8 1, ptr getelementptr inbounds (%"struct.rally::Stream", ptr @_ZN12_GLOBAL__N_16streamE, i24 0, i32 2), align 1, !tbaa !26
  br label %265

265:                                              ; preds = %264, %261
  call void @_ZN5rally6Stream4wordEi(ptr noundef nonnull align 1 dereferenceable(4100) @_ZN12_GLOBAL__N_16streamE, i24 noundef 63800) #18
  br label %266

266:                                              ; preds = %280, %265
  %267 = phi i24 [ 0, %265 ], [ %281, %280 ]
  %268 = icmp eq i24 %267, 16
  br i1 %268, label %269, label %271

269:                                              ; preds = %266
  call fastcc void @_ZN12_GLOBAL__N_15flushEv() #18
  call void @vdp_select_bitmap(i24 noundef %234) #17
  call void @vdp_adv_bitmap_from_buffer(i24 noundef 64, i24 noundef 64, i24 noundef 1) #17
  %270 = add nuw nsw i24 %230, 1
  br label %229, !llvm.loop !33

271:                                              ; preds = %266
  %272 = load i24, ptr getelementptr inbounds (%"struct.rally::Stream", ptr @_ZN12_GLOBAL__N_16streamE, i24 0, i32 1), align 1, !tbaa !24
  %273 = icmp ult i24 %272, 4096
  br i1 %273, label %274, label %279

274:                                              ; preds = %271
  %275 = getelementptr inbounds i8, ptr %233, i24 %267
  %276 = load i8, ptr %275, align 1, !tbaa !22
  %277 = add nuw nsw i24 %272, 1
  store i24 %277, ptr getelementptr inbounds (%"struct.rally::Stream", ptr @_ZN12_GLOBAL__N_16streamE, i24 0, i32 1), align 1, !tbaa !24
  %278 = getelementptr inbounds [4096 x i8], ptr @_ZN12_GLOBAL__N_16streamE, i24 0, i24 %272
  store i8 %276, ptr %278, align 1, !tbaa !22
  br label %280

279:                                              ; preds = %271
  store i8 1, ptr getelementptr inbounds (%"struct.rally::Stream", ptr @_ZN12_GLOBAL__N_16streamE, i24 0, i32 2), align 1, !tbaa !26
  br label %280

280:                                              ; preds = %279, %274
  %281 = add nuw nsw i24 %267, 1
  br label %266

282:                                              ; preds = %229
  call void @vdp_adv_clear_buffer(i24 noundef 63800) #17
  call fastcc void @_ZN12_GLOBAL__N_111resetMotionEv() #18
  call fastcc void @_ZN12_GLOBAL__N_112phaseChangedEv() #18
  %283 = load i8, ptr @_ZN12_GLOBAL__N_15mutedE, align 1, !tbaa !12, !range !34
  %284 = icmp eq i8 %283, 0
  br i1 %284, label %285, label %286

285:                                              ; preds = %282
  call void @_ZN5rally4game6Engine5startIPFvPKhjEEEvT_(ptr noundef nonnull align 1 dereferenceable(4) @_ZN12_GLOBAL__N_16engineE, ptr noundef nonnull @_ZN12_GLOBAL__N_14sendEPKhj) #18
  br label %286

286:                                              ; preds = %285, %282
  %287 = call fastcc noundef i32 @_ZN12_GLOBAL__N_18rawClockEv() #18
  br label %288

288:                                              ; preds = %967, %286
  %289 = phi i32 [ %287, %286 ], [ %969, %967 ]
  %290 = phi i32 [ %287, %286 ], [ %968, %967 ]
  br label %291

291:                                              ; preds = %288, %293
  %292 = load i1, ptr @_ZN12_GLOBAL__N_14quitE, align 1
  br i1 %292, label %970, label %293

293:                                              ; preds = %291
  %294 = call fastcc noundef i32 @_ZN12_GLOBAL__N_18rawClockEv() #18
  %295 = sub i32 %294, %289
  %296 = icmp sgt i32 %295, -1
  br i1 %296, label %297, label %291, !llvm.loop !35

297:                                              ; preds = %293
  call void @llvm.memcpy.p0.p0.i24(ptr noundef nonnull align 1 dereferenceable(16) @_ZN12_GLOBAL__N_112previousKeysE, ptr noundef nonnull align 1 dereferenceable(16) @_ZN12_GLOBAL__N_18heldKeysE, i24 16, i1 false)
  br label %298

298:                                              ; preds = %430, %297
  %299 = phi i24 [ 0, %297 ], [ %434, %430 ]
  %300 = icmp eq i24 %299, 16
  br i1 %300, label %301, label %430

301:                                              ; preds = %298, %313
  %302 = phi ptr [ %316, %313 ], [ @_ZN12_GLOBAL__N_18heldKeysE, %298 ]
  %303 = phi i8 [ %315, %313 ], [ 0, %298 ]
  %304 = icmp eq ptr %302, getelementptr inbounds ([16 x i8], ptr @_ZN12_GLOBAL__N_18heldKeysE, i24 1, i24 0)
  br i1 %304, label %305, label %308

305:                                              ; preds = %301
  %306 = sub i32 %294, %290
  %307 = icmp eq i8 %303, 0
  br i1 %307, label %317, label %318

308:                                              ; preds = %301
  %309 = icmp eq i8 %303, 0
  br i1 %309, label %310, label %313

310:                                              ; preds = %308
  %311 = load i8, ptr %302, align 1, !tbaa !22
  %312 = icmp ne i8 %311, 0
  br label %313

313:                                              ; preds = %310, %308
  %314 = phi i1 [ true, %308 ], [ %312, %310 ]
  %315 = zext i1 %314 to i8
  %316 = getelementptr inbounds i8, ptr %302, i24 1
  br label %301

317:                                              ; preds = %305
  store i1 true, ptr @_ZN12_GLOBAL__N_110inputArmedE, align 1
  br label %318

318:                                              ; preds = %317, %305
  %319 = call fastcc noundef i1 @_ZN12_GLOBAL__N_17pressedEi(i24 noundef 102) #18
  br i1 %319, label %320, label %326

320:                                              ; preds = %318
  %321 = load i8, ptr @_ZN12_GLOBAL__N_15mutedE, align 1, !tbaa !12, !range !34
  %322 = icmp eq i8 %321, 0
  %323 = xor i8 %321, 1
  store i8 %323, ptr @_ZN12_GLOBAL__N_15mutedE, align 1, !tbaa !12
  br i1 %322, label %324, label %325

324:                                              ; preds = %320
  call void @_ZN5rally4game6Engine4stopIPFvPKhjEEEvT_(ptr noundef nonnull align 1 dereferenceable(4) @_ZN12_GLOBAL__N_16engineE, ptr noundef nonnull @_ZN12_GLOBAL__N_14sendEPKhj) #18
  br label %326

325:                                              ; preds = %320
  call void @_ZN5rally4game6Engine5startIPFvPKhjEEEvT_(ptr noundef nonnull align 1 dereferenceable(4) @_ZN12_GLOBAL__N_16engineE, ptr noundef nonnull @_ZN12_GLOBAL__N_14sendEPKhj) #18
  br label %326

326:                                              ; preds = %325, %324, %318
  %327 = call fastcc noundef i1 @_ZN12_GLOBAL__N_17pressedEi(i24 noundef 113) #18
  %328 = load i8, ptr getelementptr inbounds (%"struct.rally::game::Rules", ptr @_ZN12_GLOBAL__N_15rulesE, i24 0, i32 2), align 1, !tbaa !36
  br i1 %327, label %329, label %337

329:                                              ; preds = %326
  %330 = icmp eq i8 %328, 0
  br i1 %330, label %331, label %334

331:                                              ; preds = %329
  %332 = load i1, ptr @_ZN12_GLOBAL__N_110inputArmedE, align 1
  br i1 %332, label %333, label %334

333:                                              ; preds = %331
  store i1 true, ptr @_ZN12_GLOBAL__N_14quitE, align 1
  br label %970

334:                                              ; preds = %331, %329
  store i8 0, ptr getelementptr inbounds (%"struct.rally::game::Rules", ptr @_ZN12_GLOBAL__N_15rulesE, i24 0, i32 2), align 1, !tbaa !36
  store i32 0, ptr getelementptr inbounds (%"struct.rally::game::Rules", ptr @_ZN12_GLOBAL__N_15rulesE, i24 0, i32 3), align 1, !tbaa !37
  %335 = load i16, ptr getelementptr inbounds (%"struct.rally::game::Rules", ptr @_ZN12_GLOBAL__N_15rulesE, i24 0, i32 14), align 1, !tbaa !38
  %336 = add i16 %335, 1
  store i16 %336, ptr getelementptr inbounds (%"struct.rally::game::Rules", ptr @_ZN12_GLOBAL__N_15rulesE, i24 0, i32 14), align 1, !tbaa !38
  br label %428

337:                                              ; preds = %326
  switch i8 %328, label %375 [
    i8 0, label %338
    i8 1, label %345
  ]

338:                                              ; preds = %337
  %339 = load i1, ptr @_ZN12_GLOBAL__N_110inputArmedE, align 1
  %340 = xor i1 %339, true
  %341 = select i1 %340, i1 true, i1 %307
  br i1 %341, label %392, label %342

342:                                              ; preds = %338
  store i8 1, ptr getelementptr inbounds (%"struct.rally::game::Rules", ptr @_ZN12_GLOBAL__N_15rulesE, i24 0, i32 2), align 1, !tbaa !36
  store i32 0, ptr getelementptr inbounds (%"struct.rally::game::Rules", ptr @_ZN12_GLOBAL__N_15rulesE, i24 0, i32 3), align 1, !tbaa !37
  %343 = load i16, ptr getelementptr inbounds (%"struct.rally::game::Rules", ptr @_ZN12_GLOBAL__N_15rulesE, i24 0, i32 14), align 1, !tbaa !38
  %344 = add i16 %343, 1
  store i16 %344, ptr getelementptr inbounds (%"struct.rally::game::Rules", ptr @_ZN12_GLOBAL__N_15rulesE, i24 0, i32 14), align 1, !tbaa !38
  br label %392

345:                                              ; preds = %337
  %346 = call fastcc noundef i1 @_ZN12_GLOBAL__N_17pressedEi(i24 noundef 26) #18
  br i1 %346, label %349, label %347

347:                                              ; preds = %345
  %348 = call fastcc noundef i1 @_ZN12_GLOBAL__N_17pressedEi(i24 noundef 122) #18
  br i1 %348, label %349, label %353

349:                                              ; preds = %347, %345
  %350 = load ptr, ptr @_ZN12_GLOBAL__N_18selectedE, align 1, !tbaa !11
  %351 = icmp eq ptr %350, @_ZN5rallyL4FujiE
  %352 = select i1 %351, ptr @_ZN5rallyL7TriOvalE, ptr @_ZN5rallyL4FujiE
  store ptr %352, ptr @_ZN12_GLOBAL__N_18selectedE, align 1, !tbaa !11
  call fastcc void @_ZN12_GLOBAL__N_19loadTrackEv() #18
  call fastcc void @_ZN12_GLOBAL__N_111resetMotionEv() #18
  store i8 0, ptr getelementptr inbounds (%"struct.rally::SceneryHistory", ptr @_ZN12_GLOBAL__N_114sceneryHistoryE, i24 0, i32 1, i24 1), align 1, !tbaa !12
  store i8 0, ptr getelementptr inbounds (%"struct.rally::SceneryHistory", ptr @_ZN12_GLOBAL__N_114sceneryHistoryE, i24 0, i32 1), align 1, !tbaa !12
  br label %353

353:                                              ; preds = %349, %347
  %354 = call fastcc noundef i1 @_ZN12_GLOBAL__N_17pressedEi(i24 noundef 58) #18
  br i1 %354, label %357, label %355

355:                                              ; preds = %353
  %356 = call fastcc noundef i1 @_ZN12_GLOBAL__N_17pressedEi(i24 noundef 42) #18
  br i1 %356, label %357, label %361

357:                                              ; preds = %355, %353
  %358 = load i8, ptr getelementptr inbounds (%"struct.rally::game::Rules", ptr @_ZN12_GLOBAL__N_15rulesE, i24 0, i32 1), align 1, !tbaa !13
  %359 = icmp eq i8 %358, 0
  %360 = zext i1 %359 to i8
  store i8 %360, ptr getelementptr inbounds (%"struct.rally::game::Rules", ptr @_ZN12_GLOBAL__N_15rulesE, i24 0, i32 1), align 1, !tbaa !13
  br label %361

361:                                              ; preds = %357, %355
  %362 = load i1, ptr @_ZN12_GLOBAL__N_110inputArmedE, align 1
  br i1 %362, label %363, label %392

363:                                              ; preds = %361
  %364 = call fastcc noundef i1 @_ZN12_GLOBAL__N_17pressedEi(i24 noundef 99) #18
  br i1 %364, label %367, label %365

365:                                              ; preds = %363
  %366 = call fastcc noundef i1 @_ZN12_GLOBAL__N_17pressedEi(i24 noundef 74) #18
  br i1 %366, label %367, label %392

367:                                              ; preds = %365, %363
  %368 = load ptr, ptr @_ZN12_GLOBAL__N_18selectedE, align 1, !tbaa !11
  %369 = getelementptr inbounds %"struct.rally::TrackDef", ptr %368, i24 0, i32 2
  %370 = load i32, ptr %369, align 1, !tbaa !39
  %371 = mul nsw i32 %370, 100
  %372 = icmp eq ptr %368, @_ZN5rallyL4FujiE
  %373 = select i1 %372, ptr @_ZN5rally4gameL9FujiRulesE, ptr @_ZN5rally4gameL9OvalRulesE
  %374 = load i24, ptr getelementptr inbounds (%"struct.rally::Motion", ptr @_ZN12_GLOBAL__N_16motionE, i24 0, i32 8), align 1, !tbaa !2
  call void @_ZN5rally4game5Rules7attemptEmNS0_8SettingsEi(ptr noundef nonnull align 1 dereferenceable(65) @_ZN12_GLOBAL__N_15rulesE, i32 noundef %371, ptr noundef nonnull byval(%"struct.rally::game::Settings") align 1 %373, i24 noundef %374) #18
  br label %392

375:                                              ; preds = %337
  %376 = add i8 %328, -7
  %377 = icmp ult i8 %376, 3
  br i1 %377, label %378, label %392

378:                                              ; preds = %375
  %379 = load i1, ptr @_ZN12_GLOBAL__N_110inputArmedE, align 1
  br i1 %379, label %380, label %392

380:                                              ; preds = %378
  %381 = call fastcc noundef i1 @_ZN12_GLOBAL__N_17pressedEi(i24 noundef 99) #18
  br i1 %381, label %384, label %382

382:                                              ; preds = %380
  %383 = call fastcc noundef i1 @_ZN12_GLOBAL__N_17pressedEi(i24 noundef 74) #18
  br i1 %383, label %384, label %392

384:                                              ; preds = %382, %380
  %385 = load ptr, ptr @_ZN12_GLOBAL__N_18selectedE, align 1, !tbaa !11
  %386 = getelementptr inbounds %"struct.rally::TrackDef", ptr %385, i24 0, i32 2
  %387 = load i32, ptr %386, align 1, !tbaa !39
  %388 = mul nsw i32 %387, 100
  %389 = icmp eq ptr %385, @_ZN5rallyL4FujiE
  %390 = select i1 %389, ptr @_ZN5rally4gameL9FujiRulesE, ptr @_ZN5rally4gameL9OvalRulesE
  %391 = load i24, ptr getelementptr inbounds (%"struct.rally::Motion", ptr @_ZN12_GLOBAL__N_16motionE, i24 0, i32 8), align 1, !tbaa !2
  call void @_ZN5rally4game5Rules7attemptEmNS0_8SettingsEi(ptr noundef nonnull align 1 dereferenceable(65) @_ZN12_GLOBAL__N_15rulesE, i32 noundef %388, ptr noundef nonnull byval(%"struct.rally::game::Settings") align 1 %390, i24 noundef %391) #18
  br label %392

392:                                              ; preds = %384, %382, %378, %375, %367, %365, %361, %342, %338
  %393 = load i8, ptr getelementptr inbounds (%"struct.rally::game::Rules", ptr @_ZN12_GLOBAL__N_15rulesE, i24 0, i32 2), align 1, !tbaa !36
  %394 = icmp ne i8 %393, 3
  %395 = icmp ne i8 %393, 6
  %396 = and i1 %394, %395
  %397 = load i16, ptr @_ZN12_GLOBAL__N_15crashE, align 1
  %398 = icmp ne i16 %397, 0
  %399 = select i1 %396, i1 true, i1 %398
  br i1 %399, label %418, label %400

400:                                              ; preds = %392
  %401 = load i8, ptr getelementptr inbounds ([16 x i8], ptr @_ZN12_GLOBAL__N_18heldKeysE, i24 0, i24 3), align 1, !tbaa !22
  %402 = and i8 %401, 2
  %403 = icmp ne i8 %402, 0
  %404 = load i8, ptr getelementptr inbounds ([16 x i8], ptr @_ZN12_GLOBAL__N_18heldKeysE, i24 0, i24 15), align 1, !tbaa !22
  %405 = and i8 %404, 2
  %406 = icmp ne i8 %405, 0
  %407 = xor i1 %403, %406
  br i1 %407, label %408, label %418

408:                                              ; preds = %400
  %409 = load i1, ptr @_ZN12_GLOBAL__N_112steeringStepE, align 1
  %410 = select i1 %409, i24 1, i24 2
  %411 = sub nsw i24 0, %410
  %412 = select i1 %406, i24 %410, i24 %411
  %413 = load i16, ptr getelementptr inbounds (%"struct.rally::Motion", ptr @_ZN12_GLOBAL__N_16motionE, i24 0, i32 6), align 1, !tbaa !41
  %414 = trunc i24 %412 to i16
  %415 = add i16 %413, %414
  %416 = call i16 @llvm.smin.i16(i16 %415, i16 21)
  %417 = call i16 @llvm.smax.i16(i16 %416, i16 -21)
  store i16 %417, ptr getelementptr inbounds (%"struct.rally::Motion", ptr @_ZN12_GLOBAL__N_16motionE, i24 0, i32 6), align 1
  br label %418

418:                                              ; preds = %408, %400, %392
  %419 = load i8, ptr getelementptr inbounds ([16 x i8], ptr @_ZN12_GLOBAL__N_18heldKeysE, i24 0, i24 2), align 1, !tbaa !22
  %420 = icmp slt i8 %419, 0
  %421 = load i8, ptr getelementptr inbounds ([16 x i8], ptr @_ZN12_GLOBAL__N_18heldKeysE, i24 0, i24 11), align 1, !tbaa !22
  %422 = and i8 %421, 32
  %423 = icmp ne i8 %422, 0
  call void @_ZN5rally6Motion9gripFrameEbb(ptr noundef nonnull align 1 dereferenceable(31) @_ZN12_GLOBAL__N_16motionE, i1 noundef %420, i1 noundef %423) #18
  %424 = load i24, ptr getelementptr inbounds (%"struct.rally::Motion", ptr @_ZN12_GLOBAL__N_16motionE, i24 0, i32 8), align 1, !tbaa !2
  %425 = load i24, ptr getelementptr inbounds (%"struct.rally::game::Rules", ptr @_ZN12_GLOBAL__N_15rulesE, i24 0, i32 19), align 1, !tbaa !42
  %426 = icmp sgt i24 %424, %425
  br i1 %426, label %427, label %428

427:                                              ; preds = %418
  store i24 %424, ptr getelementptr inbounds (%"struct.rally::game::Rules", ptr @_ZN12_GLOBAL__N_15rulesE, i24 0, i32 19), align 1, !tbaa !42
  br label %428

428:                                              ; preds = %418, %427, %334
  call fastcc void @_ZN12_GLOBAL__N_112phaseChangedEv() #18
  %429 = load i1, ptr @_ZN12_GLOBAL__N_14quitE, align 1
  br i1 %429, label %970, label %435

430:                                              ; preds = %298
  %431 = trunc i24 %299 to i8
  %432 = call i8 @vdp_getKeyMap(i8 noundef %431) #17
  %433 = getelementptr inbounds [16 x i8], ptr @_ZN12_GLOBAL__N_18heldKeysE, i24 0, i24 %299
  store i8 %432, ptr %433, align 1, !tbaa !22
  %434 = add nuw nsw i24 %299, 1
  br label %298, !llvm.loop !43

435:                                              ; preds = %428
  %436 = load i8, ptr getelementptr inbounds (%"struct.rally::game::Rules", ptr @_ZN12_GLOBAL__N_15rulesE, i24 0, i32 2), align 1, !tbaa !36
  %437 = icmp eq i8 %436, 0
  br i1 %437, label %438, label %439

438:                                              ; preds = %435
  call void @_ZN5rally10DemoDriver5frameERNS_6MotionE(ptr noundef nonnull align 1 dereferenceable(3) @_ZN12_GLOBAL__N_110demoDriverE, ptr noundef nonnull align 1 dereferenceable(31) @_ZN12_GLOBAL__N_16motionE) #18
  br label %439

439:                                              ; preds = %438, %435
  br label %440

440:                                              ; preds = %439, %600
  %441 = phi i32 [ %602, %600 ], [ 0, %439 ]
  %442 = icmp ult i32 %441, %306
  br i1 %442, label %446, label %443

443:                                              ; preds = %440
  %444 = load i32, ptr getelementptr inbounds (%"struct.rally::Motion", ptr @_ZN12_GLOBAL__N_16motionE, i24 0, i32 3), align 1, !tbaa !44
  call void @_ZN5rally4game6Engine6updateIPFvPKhjEEEvlT_(ptr noundef nonnull align 1 dereferenceable(4) @_ZN12_GLOBAL__N_16engineE, i32 noundef %444, ptr noundef nonnull @_ZN12_GLOBAL__N_14sendEPKhj) #18
  call void @_ZN5rally4game16prepareGameSceneINS_10DirectRoadEEEvRNS_6MotionERNS_7TrafficERKNS0_11RaceTrafficERT_RNS_14SceneryHistoryERVNS_3r1810SceneStateEb(ptr noundef nonnull align 1 dereferenceable(31) @_ZN12_GLOBAL__N_16motionE, ptr noundef nonnull align 1 dereferenceable(60) @_ZN12_GLOBAL__N_17trafficE, ptr noundef nonnull align 1 dereferenceable(197) @_ZN12_GLOBAL__N_111raceTrafficE, ptr noundef nonnull align 1 dereferenceable(2191) @_ZN12_GLOBAL__N_14roadE, ptr noundef nonnull align 1 dereferenceable(11) @_ZN12_GLOBAL__N_114sceneryHistoryE, ptr noundef nonnull align 1 dereferenceable(158) @_ZN12_GLOBAL__N_15sceneE, i1 noundef false) #18
  call void @_ZN5rally4game10Billboards7prepareINS_10DirectRoadEEEvRKNS_6MotionERKT_(ptr noundef nonnull align 1 dereferenceable(27) @_ZN12_GLOBAL__N_110billboardsE, ptr noundef nonnull align 1 dereferenceable(31) @_ZN12_GLOBAL__N_16motionE, ptr noundef nonnull align 1 dereferenceable(2191) @_ZN12_GLOBAL__N_14roadE) #18
  %445 = load i8, ptr getelementptr inbounds (%"struct.rally::game::Rules", ptr @_ZN12_GLOBAL__N_15rulesE, i24 0, i32 2), align 1, !tbaa !36
  switch i8 %445, label %603 [
    i8 6, label %604
    i8 0, label %604
  ]

446:                                              ; preds = %440
  %447 = load i8, ptr getelementptr inbounds (%"struct.rally::game::Rules", ptr @_ZN12_GLOBAL__N_15rulesE, i24 0, i32 2), align 1, !tbaa !36
  switch i8 %447, label %589 [
    i8 0, label %448
    i8 6, label %472
    i8 3, label %472
  ]

448:                                              ; preds = %446
  store i8 1, ptr getelementptr inbounds (%"struct.rally::Motion", ptr @_ZN12_GLOBAL__N_16motionE, i24 0, i32 9), align 1, !tbaa !45
  call void @_ZNK5rally10DemoDriver4tickERNS_6MotionE(ptr noundef nonnull align 1 dereferenceable(3) @_ZN12_GLOBAL__N_110demoDriverE, ptr noundef nonnull align 1 dereferenceable(31) @_ZN12_GLOBAL__N_16motionE) #18
  %449 = load i32, ptr getelementptr inbounds (%"struct.rally::Motion", ptr @_ZN12_GLOBAL__N_16motionE, i24 0, i32 3), align 1, !tbaa !44
  %450 = shl nsw i32 %449, 1
  %451 = load i32, ptr @_ZN12_GLOBAL__N_115attractProgressE, align 1, !tbaa !46
  %452 = add i32 %451, %450
  store i32 %452, ptr @_ZN12_GLOBAL__N_115attractProgressE, align 1, !tbaa !46
  %453 = load i32, ptr getelementptr inbounds (%"struct.rally::game::Rules", ptr @_ZN12_GLOBAL__N_15rulesE, i24 0, i32 3), align 1, !tbaa !37
  %454 = add i32 %453, 1
  call void @_ZN5rally4game11RaceTraffic4tickEmm(ptr noundef nonnull align 1 dereferenceable(197) @_ZN12_GLOBAL__N_111raceTrafficE, i32 noundef %452, i32 noundef %454) #18
  %455 = load ptr, ptr @_ZN12_GLOBAL__N_18selectedE, align 1, !tbaa !11
  %456 = getelementptr inbounds %"struct.rally::TrackDef", ptr %455, i24 0, i32 2
  %457 = load i32, ptr %456, align 1, !tbaa !39
  %458 = mul i32 %457, 100
  %459 = load i32, ptr @_ZN12_GLOBAL__N_115attractProgressE, align 1, !tbaa !46
  %460 = icmp ult i32 %459, %458
  br i1 %460, label %589, label %461

461:                                              ; preds = %448
  %462 = sub i32 %459, %458
  store i32 %462, ptr @_ZN12_GLOBAL__N_115attractProgressE, align 1, !tbaa !46
  br label %463

463:                                              ; preds = %466, %461
  %464 = phi ptr [ @_ZN12_GLOBAL__N_111raceTrafficE, %461 ], [ %471, %466 ]
  %465 = icmp eq ptr %464, getelementptr inbounds (%"struct.rally::game::RaceTraffic", ptr @_ZN12_GLOBAL__N_111raceTrafficE, i24 0, i32 1, i32 0)
  br i1 %465, label %589, label %466

466:                                              ; preds = %463
  %467 = getelementptr inbounds %"struct.rally::game::RaceCar", ptr %464, i24 0, i32 4
  %468 = load i32, ptr %467, align 1, !tbaa !47
  %469 = getelementptr inbounds %"struct.rally::game::RaceCar", ptr %464, i24 0, i32 3
  store i32 %468, ptr %469, align 1, !tbaa !50
  %470 = getelementptr inbounds %"struct.rally::game::RaceCar", ptr %464, i24 0, i32 6
  store i32 0, ptr %470, align 1, !tbaa !51
  %471 = getelementptr inbounds %"struct.rally::game::RaceCar", ptr %464, i24 1
  br label %463

472:                                              ; preds = %446, %446
  %473 = load i32, ptr getelementptr inbounds (%"struct.rally::game::Rules", ptr @_ZN12_GLOBAL__N_15rulesE, i24 0, i32 11), align 1, !tbaa !52
  %474 = load ptr, ptr @_ZN12_GLOBAL__N_18selectedE, align 1, !tbaa !11
  %475 = getelementptr inbounds %"struct.rally::TrackDef", ptr %474, i24 0, i32 2
  %476 = load i32, ptr %475, align 1, !tbaa !39
  %477 = mul nsw i32 %476, 100
  %478 = load i32, ptr getelementptr inbounds (%"struct.rally::Motion", ptr @_ZN12_GLOBAL__N_16motionE, i24 0, i32 2), align 1, !tbaa !53
  %479 = add nsw i32 %478, 6800
  %480 = icmp slt i32 %479, %477
  %481 = select i1 %480, i32 0, i32 %477
  %482 = sub nsw i32 %479, %481
  call void @llvm.lifetime.start.p0(i64 24, ptr nonnull %9) #19
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %10) #19
  %483 = mul nsw i32 %476, 50
  %484 = mul nsw i32 %476, -50
  %485 = sub i32 0, %477
  br label %486

486:                                              ; preds = %507, %472
  %487 = phi i24 [ 0, %472 ], [ %510, %507 ]
  %488 = icmp eq i24 %487, 6
  br i1 %488, label %489, label %491

489:                                              ; preds = %486
  store i8 0, ptr getelementptr inbounds (%"struct.rally::Motion", ptr @_ZN12_GLOBAL__N_16motionE, i24 0, i32 9), align 1, !tbaa !45
  store i16 0, ptr getelementptr inbounds (%"struct.rally::Motion", ptr @_ZN12_GLOBAL__N_16motionE, i24 0, i32 7), align 1, !tbaa !54
  %490 = call noundef i1 @_ZN5rally4game5Crash4tickERNS_6MotionERKNS0_11RaceTrafficEm(ptr noundef nonnull align 1 dereferenceable(4) @_ZN12_GLOBAL__N_15crashE, ptr noundef nonnull align 1 dereferenceable(31) @_ZN12_GLOBAL__N_16motionE, ptr noundef nonnull align 1 dereferenceable(197) @_ZN12_GLOBAL__N_111raceTrafficE, i32 noundef %473) #18
  br i1 %490, label %520, label %511

491:                                              ; preds = %486
  %492 = getelementptr inbounds [6 x %"struct.rally::game::RaceCar"], ptr @_ZN12_GLOBAL__N_111raceTrafficE, i24 0, i24 %487
  %493 = getelementptr inbounds [6 x %"struct.rally::game::RaceCar"], ptr @_ZN12_GLOBAL__N_111raceTrafficE, i24 0, i24 %487, i32 4
  %494 = load i32, ptr %493, align 1, !tbaa !47
  %495 = sub nsw i32 %494, %482
  %496 = icmp sgt i32 %495, %483
  %497 = icmp slt i32 %495, %484
  %498 = select i1 %497, i32 %477, i32 0
  %499 = select i1 %496, i32 %485, i32 %498
  %500 = add i32 %499, %495
  %501 = getelementptr inbounds [6 x i32], ptr %9, i24 0, i24 %487
  store i32 %500, ptr %501, align 1, !tbaa !46
  %502 = load i8, ptr %492, align 1, !tbaa !55, !range !34
  %503 = icmp eq i8 %502, 0
  br i1 %503, label %507, label %504

504:                                              ; preds = %491
  %505 = getelementptr inbounds [6 x %"struct.rally::game::RaceCar"], ptr @_ZN12_GLOBAL__N_111raceTrafficE, i24 0, i24 %487, i32 1
  %506 = load i16, ptr %505, align 1, !tbaa !56
  br label %507

507:                                              ; preds = %504, %491
  %508 = phi i16 [ %506, %504 ], [ 0, %491 ]
  %509 = getelementptr inbounds [6 x i16], ptr %10, i24 0, i24 %487
  store i16 %508, ptr %509, align 1, !tbaa !57
  %510 = add nuw nsw i24 %487, 1
  br label %486, !llvm.loop !58

511:                                              ; preds = %489
  %512 = load i8, ptr getelementptr inbounds ([16 x i8], ptr @_ZN12_GLOBAL__N_18heldKeysE, i24 0, i24 7), align 1, !tbaa !22
  %513 = and i8 %512, 2
  %514 = icmp ne i8 %513, 0
  %515 = load i8, ptr getelementptr inbounds ([16 x i8], ptr @_ZN12_GLOBAL__N_18heldKeysE, i24 0, i24 5), align 1, !tbaa !22
  %516 = and i8 %515, 2
  %517 = icmp ne i8 %516, 0
  call void @_ZN5rally6Motion4tickEbb(ptr noundef nonnull align 1 dereferenceable(31) @_ZN12_GLOBAL__N_16motionE, i1 noundef %514, i1 noundef %517) #18
  %518 = load i32, ptr getelementptr inbounds (%"struct.rally::Motion", ptr @_ZN12_GLOBAL__N_16motionE, i24 0, i32 3), align 1, !tbaa !44
  %519 = shl nsw i32 %518, 1
  br label %520

520:                                              ; preds = %511, %489
  %521 = phi i32 [ 0, %489 ], [ %519, %511 ]
  %522 = load i8, ptr getelementptr inbounds (%"struct.rally::game::Rules", ptr @_ZN12_GLOBAL__N_15rulesE, i24 0, i32 2), align 1, !tbaa !36
  %523 = icmp eq i8 %522, 6
  br i1 %523, label %524, label %588

524:                                              ; preds = %520
  %525 = add i32 %521, %473
  %526 = add i32 %521, %482
  %527 = icmp slt i32 %526, %477
  %528 = select i1 %527, i32 0, i32 %477
  %529 = sub nsw i32 %526, %528
  %530 = load i32, ptr getelementptr inbounds (%"struct.rally::game::Rules", ptr @_ZN12_GLOBAL__N_15rulesE, i24 0, i32 4), align 1, !tbaa !59
  %531 = add i32 %530, 1
  call void @_ZN5rally4game11RaceTraffic4tickEmm(ptr noundef nonnull align 1 dereferenceable(197) @_ZN12_GLOBAL__N_111raceTrafficE, i32 noundef %525, i32 noundef %531) #18
  %532 = load i16, ptr getelementptr inbounds (%"struct.rally::game::Crash", ptr @_ZN12_GLOBAL__N_15crashE, i24 0, i32 1), align 1
  %533 = icmp ne i16 %532, 0
  %534 = select i1 %490, i1 true, i1 %533
  br i1 %534, label %539, label %535

535:                                              ; preds = %524
  %536 = load i32, ptr getelementptr inbounds (%"struct.rally::Motion", ptr @_ZN12_GLOBAL__N_16motionE, i24 0, i32 4), align 1, !tbaa !60
  %537 = call noundef i1 @_ZNK5rally4game11RaceTraffic14contactStationEll(ptr noundef nonnull align 1 dereferenceable(197) @_ZN12_GLOBAL__N_111raceTrafficE, i32 noundef %529, i32 noundef %536) #18
  br i1 %537, label %538, label %539

538:                                              ; preds = %535
  store i16 150, ptr @_ZN12_GLOBAL__N_15crashE, align 1, !tbaa !61
  store i32 0, ptr getelementptr inbounds (%"struct.rally::Motion", ptr @_ZN12_GLOBAL__N_16motionE, i24 0, i32 3), align 1, !tbaa !44
  store i32 0, ptr getelementptr inbounds (%"struct.rally::Motion", ptr @_ZN12_GLOBAL__N_16motionE, i24 0, i32 5), align 1, !tbaa !63
  br label %539

539:                                              ; preds = %538, %535, %524
  %540 = load i16, ptr @_ZN12_GLOBAL__N_15crashE, align 1
  %541 = icmp ne i16 %540, 0
  %542 = select i1 %490, i1 true, i1 %541
  br i1 %542, label %583, label %543

543:                                              ; preds = %539
  %544 = load i32, ptr getelementptr inbounds (%"struct.rally::game::Rules", ptr @_ZN12_GLOBAL__N_15rulesE, i24 0, i32 10), align 1, !tbaa !64
  br label %545

545:                                              ; preds = %580, %543
  %546 = phi i32 [ %581, %580 ], [ %544, %543 ]
  %547 = phi i24 [ %582, %580 ], [ 0, %543 ]
  %548 = icmp eq i24 %547, 6
  br i1 %548, label %583, label %549

549:                                              ; preds = %545
  %550 = getelementptr inbounds [6 x %"struct.rally::game::RaceCar"], ptr @_ZN12_GLOBAL__N_111raceTrafficE, i24 0, i24 %547
  %551 = load i8, ptr %550, align 1, !tbaa !55, !range !34
  %552 = icmp eq i8 %551, 0
  br i1 %552, label %580, label %553

553:                                              ; preds = %549
  %554 = getelementptr inbounds [6 x i16], ptr %10, i24 0, i24 %547
  %555 = load i16, ptr %554, align 1, !tbaa !57
  %556 = getelementptr inbounds [6 x %"struct.rally::game::RaceCar"], ptr @_ZN12_GLOBAL__N_111raceTrafficE, i24 0, i24 %547, i32 1
  %557 = load i16, ptr %556, align 1, !tbaa !56
  %558 = icmp eq i16 %555, %557
  br i1 %558, label %559, label %580

559:                                              ; preds = %553
  %560 = getelementptr inbounds [6 x i32], ptr %9, i24 0, i24 %547
  %561 = load i32, ptr %560, align 1, !tbaa !46
  %562 = getelementptr inbounds [6 x %"struct.rally::game::RaceCar"], ptr @_ZN12_GLOBAL__N_111raceTrafficE, i24 0, i24 %547, i32 4
  %563 = load i32, ptr %562, align 1, !tbaa !47
  %564 = sub nsw i32 %563, %529
  %565 = icmp sgt i32 %564, %483
  %566 = icmp slt i32 %564, %484
  %567 = select i1 %566, i32 %477, i32 0
  %568 = select i1 %565, i32 %485, i32 %567
  %569 = add i32 %568, %564
  %570 = icmp sgt i32 %561, 0
  %571 = icmp ule i32 %561, %521
  %572 = icmp slt i32 %569, 1
  %573 = and i1 %570, %571
  %574 = and i1 %573, %572
  br i1 %574, label %575, label %580

575:                                              ; preds = %559
  %576 = add i32 %546, -9999900
  %577 = icmp ult i32 %576, 100
  %578 = add i32 %546, 100
  %579 = select i1 %577, i32 9999999, i32 %578
  store i32 %579, ptr getelementptr inbounds (%"struct.rally::game::Rules", ptr @_ZN12_GLOBAL__N_15rulesE, i24 0, i32 10), align 1, !tbaa !64
  br label %580

580:                                              ; preds = %575, %559, %553, %549
  %581 = phi i32 [ %579, %575 ], [ %546, %559 ], [ %546, %553 ], [ %546, %549 ]
  %582 = add nuw nsw i24 %547, 1
  br label %545, !llvm.loop !65

583:                                              ; preds = %545, %539
  %584 = load i8, ptr getelementptr inbounds (%"struct.rally::game::Rules", ptr @_ZN12_GLOBAL__N_15rulesE, i24 0, i32 1), align 1, !tbaa !13
  %585 = icmp eq i8 %584, 0
  br i1 %585, label %586, label %588

586:                                              ; preds = %583
  %587 = call noundef i8 @_ZNK5rally4game11RaceTraffic4rankEmm(ptr noundef nonnull align 1 dereferenceable(197) @_ZN12_GLOBAL__N_111raceTrafficE, i32 noundef %525, i32 noundef 0) #18
  store i8 %587, ptr getelementptr inbounds (%"struct.rally::game::Rules", ptr @_ZN12_GLOBAL__N_15rulesE, i24 0, i32 18), align 1, !tbaa !66
  br label %588

588:                                              ; preds = %586, %583, %520
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %10) #19
  call void @llvm.lifetime.end.p0(i64 24, ptr nonnull %9) #19
  br label %589

589:                                              ; preds = %463, %588, %448, %446
  %590 = phi i32 [ %521, %588 ], [ 0, %448 ], [ 0, %446 ], [ 0, %463 ]
  call void @_ZN5rally4game5Rules4tickEm(ptr noundef nonnull align 1 dereferenceable(65) @_ZN12_GLOBAL__N_15rulesE, i32 noundef %590) #18
  %591 = load i8, ptr getelementptr inbounds (%"struct.rally::game::Rules", ptr @_ZN12_GLOBAL__N_15rulesE, i24 0, i32 2), align 1, !tbaa !36
  %592 = icmp eq i8 %591, 7
  %593 = load i8, ptr getelementptr inbounds (%"struct.rally::game::Rules", ptr @_ZN12_GLOBAL__N_15rulesE, i24 0, i32 1), align 1
  %594 = icmp eq i8 %593, 0
  %595 = select i1 %592, i1 %594, i1 false
  br i1 %595, label %596, label %600

596:                                              ; preds = %589
  %597 = load i32, ptr getelementptr inbounds (%"struct.rally::game::Rules", ptr @_ZN12_GLOBAL__N_15rulesE, i24 0, i32 11), align 1, !tbaa !52
  %598 = load i32, ptr getelementptr inbounds (%"struct.rally::game::Rules", ptr @_ZN12_GLOBAL__N_15rulesE, i24 0, i32 4), align 1, !tbaa !59
  %599 = call noundef i8 @_ZNK5rally4game11RaceTraffic4rankEmm(ptr noundef nonnull align 1 dereferenceable(197) @_ZN12_GLOBAL__N_111raceTrafficE, i32 noundef %597, i32 noundef %598) #18
  store i8 %599, ptr getelementptr inbounds (%"struct.rally::game::Rules", ptr @_ZN12_GLOBAL__N_15rulesE, i24 0, i32 18), align 1, !tbaa !66
  br label %600

600:                                              ; preds = %589, %596
  call fastcc void @_ZN12_GLOBAL__N_112phaseChangedEv() #18
  %601 = load i32, ptr getelementptr inbounds (%"struct.rally::Motion", ptr @_ZN12_GLOBAL__N_16motionE, i24 0, i32 2), align 1, !tbaa !53
  call void @_ZNK5rally4game11RaceTraffic4viewERNS_7TrafficEl(ptr noundef nonnull align 1 dereferenceable(197) @_ZN12_GLOBAL__N_111raceTrafficE, ptr noundef nonnull align 1 dereferenceable(60) @_ZN12_GLOBAL__N_17trafficE, i32 noundef %601) #18
  %602 = add i32 %441, 1
  br label %440, !llvm.loop !67

603:                                              ; preds = %443
  store i24 0, ptr getelementptr inbounds (%"struct.rally::r18::SceneState", ptr @_ZN12_GLOBAL__N_15sceneE, i24 0, i32 9), align 1, !tbaa !68
  br label %604

604:                                              ; preds = %443, %443, %603
  %605 = icmp ne i8 %445, 3
  %606 = icmp ne i8 %445, 6
  %607 = and i1 %605, %606
  %608 = select i1 %607, i24 88, i24 24
  %609 = load i24, ptr @_ZN12_GLOBAL__N_15sceneE, align 1, !tbaa !70
  call void @vdp_adv_use_affine_matrix(i8 noundef 1, i16 noundef -1) #17
  %610 = load i24, ptr getelementptr inbounds (%"struct.rally::r18::SceneState", ptr @_ZN12_GLOBAL__N_15sceneE, i24 0, i32 1), align 1, !tbaa !71
  %611 = icmp eq i24 %610, 0
  br i1 %611, label %617, label %612

612:                                              ; preds = %604
  call void @_ZN5rally4game11skyViewportERNS_6StreamEiiii(ptr noundef nonnull align 1 dereferenceable(4100) @_ZN12_GLOBAL__N_16streamE, i24 noundef 0, i24 noundef %608, i24 noundef 319, i24 noundef 103) #18
  call fastcc void @_ZN12_GLOBAL__N_15flushEv() #18
  %613 = load i24, ptr getelementptr inbounds (%"struct.rally::r18::SceneState", ptr @_ZN12_GLOBAL__N_15sceneE, i24 0, i32 1), align 1, !tbaa !71
  %614 = icmp sgt i24 %613, 0
  %615 = zext i1 %614 to i24
  %616 = call i24 @llvm.abs.i24(i24 %613, i1 true)
  call void @vdp_scroll_screen_extent(i24 noundef 2, i24 noundef %615, i24 noundef %616) #17
  br label %617

617:                                              ; preds = %612, %604
  call void @vdp_select_bitmap(i24 noundef 100) #17
  %618 = load i8, ptr getelementptr inbounds (%"struct.rally::r18::SceneState", ptr @_ZN12_GLOBAL__N_15sceneE, i24 0, i32 4), align 1, !tbaa !72, !range !34
  %619 = icmp eq i8 %618, 0
  br i1 %619, label %632, label %620

620:                                              ; preds = %617
  %621 = load i24, ptr getelementptr inbounds (%"struct.rally::r18::SceneState", ptr @_ZN12_GLOBAL__N_15sceneE, i24 0, i32 2), align 1, !tbaa !73
  %622 = load i24, ptr getelementptr inbounds (%"struct.rally::r18::SceneState", ptr @_ZN12_GLOBAL__N_15sceneE, i24 0, i32 3), align 1, !tbaa !74
  call void @_ZN5rally4game11skyViewportERNS_6StreamEiiii(ptr noundef nonnull align 1 dereferenceable(4100) @_ZN12_GLOBAL__N_16streamE, i24 noundef %621, i24 noundef %608, i24 noundef %622, i24 noundef 103) #18
  call fastcc void @_ZN12_GLOBAL__N_15flushEv() #18
  %623 = sub nsw i24 1024, %609
  %624 = load i24, ptr getelementptr inbounds (%"struct.rally::r18::SceneState", ptr @_ZN12_GLOBAL__N_15sceneE, i24 0, i32 2), align 1, !tbaa !73
  %625 = icmp sgt i24 %623, %624
  br i1 %625, label %626, label %628

626:                                              ; preds = %620
  %627 = sub nsw i24 0, %609
  call void @vdp_draw_bitmap(i24 noundef %627, i24 noundef 0) #17
  br label %628

628:                                              ; preds = %626, %620
  %629 = load i24, ptr getelementptr inbounds (%"struct.rally::r18::SceneState", ptr @_ZN12_GLOBAL__N_15sceneE, i24 0, i32 3), align 1, !tbaa !74
  %630 = icmp sgt i24 %623, %629
  br i1 %630, label %632, label %631

631:                                              ; preds = %628
  call void @vdp_draw_bitmap(i24 noundef %623, i24 noundef 0) #17
  br label %632

632:                                              ; preds = %631, %628, %617
  %633 = load i8, ptr getelementptr inbounds (%"struct.rally::r18::SceneState", ptr @_ZN12_GLOBAL__N_15sceneE, i24 0, i32 4), align 1, !tbaa !72, !range !34
  %634 = icmp eq i8 %633, 0
  %635 = load i24, ptr getelementptr inbounds (%"struct.rally::r18::SceneState", ptr @_ZN12_GLOBAL__N_15sceneE, i24 0, i32 1), align 1
  %636 = icmp ne i24 %635, 0
  %637 = select i1 %634, i1 true, i1 %636
  br i1 %637, label %638, label %643

638:                                              ; preds = %632
  call void @_ZN5rally4game8viewportERNS_6StreamEiiii(ptr noundef nonnull align 1 dereferenceable(4100) @_ZN12_GLOBAL__N_16streamE, i24 noundef 0, i24 noundef 88, i24 noundef 319, i24 noundef 103) #18
  call fastcc void @_ZN12_GLOBAL__N_15flushEv() #18
  %639 = sub nsw i24 0, %609
  call void @vdp_draw_bitmap(i24 noundef %639, i24 noundef 0) #17
  %640 = icmp sgt i24 %609, 704
  br i1 %640, label %641, label %643

641:                                              ; preds = %638
  %642 = sub nsw i24 1024, %609
  call void @vdp_draw_bitmap(i24 noundef %642, i24 noundef 0) #17
  br label %643

643:                                              ; preds = %632, %638, %641
  call void @_ZN5rally4game8viewportERNS_6StreamEiiii(ptr noundef nonnull align 1 dereferenceable(4100) @_ZN12_GLOBAL__N_16streamE, i24 noundef 0, i24 noundef 104, i24 noundef 319, i24 noundef 239) #18
  call fastcc void @_ZN12_GLOBAL__N_15flushEv() #18
  call void @_ZN5rally10DirectRoad6emitToIPFvPKhjEEEvRNS_6StreamET_b(ptr noundef nonnull align 1 dereferenceable(2191) @_ZN12_GLOBAL__N_14roadE, ptr noundef nonnull align 1 dereferenceable(4100) @_ZN12_GLOBAL__N_16streamE, ptr noundef nonnull @_ZN12_GLOBAL__N_14sendEPKhj, i1 noundef false) #18
  %644 = load i32, ptr getelementptr inbounds (%"struct.rally::Motion", ptr @_ZN12_GLOBAL__N_16motionE, i24 0, i32 2), align 1, !tbaa !53
  %645 = load ptr, ptr @_ZN12_GLOBAL__N_18selectedE, align 1, !tbaa !11
  %646 = getelementptr inbounds %"struct.rally::TrackDef", ptr %645, i24 0, i32 2
  %647 = load i32, ptr %646, align 1, !tbaa !39
  %648 = mul nsw i32 %647, 100
  %649 = sub i32 %648, %644
  %650 = srem i32 %649, %648
  %651 = add i32 %650, -100100
  %652 = icmp ult i32 %651, -93700
  br i1 %652, label %699, label %653

653:                                              ; preds = %643
  %654 = udiv i32 %650, 100
  %655 = trunc i32 %654 to i16
  %656 = udiv i16 8000, %655
  %657 = zext i16 %656 to i24
  %658 = lshr i16 %656, 4
  %659 = zext i16 %658 to i24
  %660 = call i24 @llvm.smax.i24(i24 %659, i24 1)
  br label %661

661:                                              ; preds = %696, %653
  %662 = phi i24 [ 0, %653 ], [ %697, %696 ]
  %663 = icmp eq i24 %662, 2
  br i1 %663, label %698, label %664

664:                                              ; preds = %661
  %665 = mul nuw nsw i24 %662, %660
  %666 = add nuw nsw i24 %665, %657
  %667 = add nuw nsw i24 %666, 96
  %668 = icmp ugt i24 %666, 127
  br i1 %668, label %698, label %669

669:                                              ; preds = %664
  %670 = call noundef i24 @_ZNK5rally10DirectRoad8centerAtEi(ptr noundef nonnull align 1 dereferenceable(2191) @_ZN12_GLOBAL__N_14roadE, i24 noundef %667) #18
  %671 = trunc i24 %666 to i16
  %672 = mul nuw nsw i16 %671, 90
  %673 = udiv i16 %672, 50
  %674 = zext i16 %673 to i24
  %675 = sub nsw i24 %670, %674
  %676 = shl nuw nsw i24 %674, 1
  %677 = add i24 %675, -1
  %678 = add nuw nsw i24 %667, %660
  %679 = call i24 @llvm.smin.i24(i24 %678, i24 224)
  %680 = add nsw i24 %679, -1
  br label %681

681:                                              ; preds = %684, %669
  %682 = phi i24 [ 0, %669 ], [ %688, %684 ]
  %683 = icmp eq i24 %682, 12
  br i1 %683, label %696, label %684

684:                                              ; preds = %681
  %685 = mul nuw nsw i24 %682, %676
  %686 = udiv i24 %685, 12
  %687 = add nsw i24 %686, %675
  %688 = add nuw nsw i24 %682, 1
  %689 = mul nuw nsw i24 %688, %676
  %690 = udiv i24 %689, 12
  %691 = add i24 %677, %690
  %692 = add nuw nsw i24 %682, %662
  %693 = and i24 %692, 1
  %694 = icmp eq i24 %693, 0
  %695 = select i1 %694, i24 0, i24 15
  call void @_ZN5rally6Stream4rectEiiiii(ptr noundef nonnull align 1 dereferenceable(4100) @_ZN12_GLOBAL__N_16streamE, i24 noundef %687, i24 noundef %667, i24 noundef %691, i24 noundef %680, i24 noundef %695) #18
  br label %681, !llvm.loop !75

696:                                              ; preds = %681
  %697 = add nuw nsw i24 %662, 1
  br label %661, !llvm.loop !76

698:                                              ; preds = %664, %661
  call fastcc void @_ZN12_GLOBAL__N_15flushEv() #18
  br label %699

699:                                              ; preds = %643, %698
  %700 = load i8, ptr getelementptr inbounds (%"struct.rally::game::Rules", ptr @_ZN12_GLOBAL__N_15rulesE, i24 0, i32 2), align 1, !tbaa !36
  %701 = icmp ne i8 %700, 3
  %702 = icmp ne i8 %700, 6
  %703 = and i1 %701, %702
  %704 = select i1 %703, i24 88, i24 24
  call void @_ZN5rally4game8viewportERNS_6StreamEiiii(ptr noundef nonnull align 1 dereferenceable(4100) @_ZN12_GLOBAL__N_16streamE, i24 noundef 0, i24 noundef %704, i24 noundef 319, i24 noundef 223) #18
  call fastcc void @_ZN12_GLOBAL__N_15flushEv() #18
  br label %705

705:                                              ; preds = %727, %699
  %706 = phi i24 [ %728, %727 ], [ 0, %699 ]
  %707 = phi i24 [ %710, %727 ], [ 0, %699 ]
  %708 = getelementptr inbounds [2 x %"struct.rally::game::SignPose"], ptr @_ZN12_GLOBAL__N_110billboardsE, i24 0, i24 %706, i32 2
  br label %709

709:                                              ; preds = %705, %742
  %710 = phi i24 [ %744, %742 ], [ %707, %705 ]
  %711 = load i24, ptr getelementptr inbounds (%"struct.rally::r18::SceneState", ptr @_ZN12_GLOBAL__N_15sceneE, i24 0, i32 9), align 1, !tbaa !68
  %712 = icmp ult i24 %710, %711
  %713 = load i24, ptr getelementptr inbounds (%"struct.rally::game::Billboards", ptr @_ZN12_GLOBAL__N_110billboardsE, i24 0, i32 1), align 1
  %714 = icmp ult i24 %706, %713
  %715 = select i1 %712, i1 true, i1 %714
  br i1 %715, label %716, label %759

716:                                              ; preds = %709
  br i1 %714, label %720, label %717

717:                                              ; preds = %716
  %718 = getelementptr inbounds %"struct.rally::r18::SceneState", ptr @_ZN12_GLOBAL__N_15sceneE, i24 0, i32 10, i24 %710, i32 2
  %719 = load i24, ptr %718, align 1, !tbaa !77
  br label %742

720:                                              ; preds = %716
  %721 = icmp eq i24 %710, %711
  br i1 %721, label %727, label %722

722:                                              ; preds = %720
  %723 = load i24, ptr %708, align 1, !tbaa !79
  %724 = getelementptr inbounds %"struct.rally::r18::SceneState", ptr @_ZN12_GLOBAL__N_15sceneE, i24 0, i32 10, i24 %710, i32 2
  %725 = load i24, ptr %724, align 1, !tbaa !77
  %726 = icmp sgt i24 %723, %725
  br i1 %726, label %742, label %727

727:                                              ; preds = %722, %720
  %728 = add nuw i24 %706, 1
  %729 = getelementptr inbounds [2 x %"struct.rally::game::SignPose"], ptr @_ZN12_GLOBAL__N_110billboardsE, i24 0, i24 %706
  call void @_ZN5rally4game8viewportERNS_6StreamEiiii(ptr noundef nonnull align 1 dereferenceable(4100) @_ZN12_GLOBAL__N_16streamE, i24 noundef 0, i24 noundef 104, i24 noundef 319, i24 noundef 223) #18
  call fastcc void @_ZN12_GLOBAL__N_15flushEv() #18
  %730 = getelementptr inbounds [2 x %"struct.rally::game::SignPose"], ptr @_ZN12_GLOBAL__N_110billboardsE, i24 0, i24 %706, i32 2
  %731 = load i24, ptr %730, align 1, !tbaa !79
  call fastcc void @_ZN12_GLOBAL__N_113trafficMatrixEjiii(i24 noundef 63930, i24 noundef %731, i24 noundef %731, i24 noundef 0) #18
  %732 = getelementptr inbounds [2 x %"struct.rally::game::SignPose"], ptr @_ZN12_GLOBAL__N_110billboardsE, i24 0, i24 %706, i32 3
  %733 = load i24, ptr %732, align 1, !tbaa !81
  call void @vdp_select_bitmap(i24 noundef %733) #17
  call void @vdp_adv_use_affine_matrix(i8 noundef 1, i16 noundef -1606) #17
  %734 = load i24, ptr %729, align 1, !tbaa !82
  %735 = getelementptr inbounds [2 x %"struct.rally::game::SignPose"], ptr @_ZN12_GLOBAL__N_110billboardsE, i24 0, i24 %706, i32 1
  %736 = load i24, ptr %735, align 1, !tbaa !83
  call void @vdp_draw_bitmap(i24 noundef %734, i24 noundef %736) #17
  %737 = load i8, ptr getelementptr inbounds (%"struct.rally::game::Rules", ptr @_ZN12_GLOBAL__N_15rulesE, i24 0, i32 2), align 1, !tbaa !36
  %738 = icmp ne i8 %737, 3
  %739 = icmp ne i8 %737, 6
  %740 = and i1 %738, %739
  %741 = select i1 %740, i24 88, i24 24
  call void @_ZN5rally4game8viewportERNS_6StreamEiiii(ptr noundef nonnull align 1 dereferenceable(4100) @_ZN12_GLOBAL__N_16streamE, i24 noundef 0, i24 noundef %741, i24 noundef 319, i24 noundef 223) #18
  call fastcc void @_ZN12_GLOBAL__N_15flushEv() #18
  br label %705, !llvm.loop !84

742:                                              ; preds = %722, %717
  %743 = phi i24 [ %719, %717 ], [ %725, %722 ]
  %744 = add i24 %710, 1
  %745 = getelementptr inbounds %"struct.rally::r18::SceneState", ptr @_ZN12_GLOBAL__N_15sceneE, i24 0, i32 10, i24 %710
  %746 = getelementptr inbounds %"struct.rally::r18::SceneState", ptr @_ZN12_GLOBAL__N_15sceneE, i24 0, i32 10, i24 %710, i32 1
  %747 = load i24, ptr %746, align 1, !tbaa !85
  %748 = getelementptr inbounds %"struct.rally::r18::SceneState", ptr @_ZN12_GLOBAL__N_15sceneE, i24 0, i32 10, i24 %710, i32 3
  %749 = load i24, ptr %748, align 1, !tbaa !86
  %750 = getelementptr inbounds %"struct.rally::r18::SceneState", ptr @_ZN12_GLOBAL__N_15sceneE, i24 0, i32 10, i24 %710, i32 4
  %751 = load i24, ptr %750, align 1, !tbaa !87
  call fastcc void @_ZN12_GLOBAL__N_113trafficMatrixEjiii(i24 noundef %747, i24 noundef %749, i24 noundef %743, i24 noundef %751) #18
  %752 = load i24, ptr %745, align 1, !tbaa !88
  call void @vdp_select_bitmap(i24 noundef %752) #17
  %753 = load i24, ptr %746, align 1, !tbaa !85
  %754 = trunc i24 %753 to i16
  call void @vdp_adv_use_affine_matrix(i8 noundef 1, i16 noundef %754) #17
  %755 = getelementptr inbounds %"struct.rally::r18::SceneState", ptr @_ZN12_GLOBAL__N_15sceneE, i24 0, i32 10, i24 %710, i32 5
  %756 = load i24, ptr %755, align 1, !tbaa !89
  %757 = getelementptr inbounds %"struct.rally::r18::SceneState", ptr @_ZN12_GLOBAL__N_15sceneE, i24 0, i32 10, i24 %710, i32 6
  %758 = load i24, ptr %757, align 1, !tbaa !90
  call void @vdp_draw_bitmap(i24 noundef %756, i24 noundef %758) #17
  br label %709, !llvm.loop !84

759:                                              ; preds = %709
  call void @vdp_adv_use_affine_matrix(i8 noundef 1, i16 noundef -1) #17
  %760 = load i16, ptr @_ZN12_GLOBAL__N_15crashE, align 1, !tbaa !61
  %761 = icmp eq i16 %760, 0
  br i1 %761, label %811, label %762

762:                                              ; preds = %759
  %763 = zext i16 %760 to i24
  %764 = sub nsw i24 150, %763
  %765 = load i24, ptr getelementptr inbounds (%"struct.rally::r18::SceneState", ptr @_ZN12_GLOBAL__N_15sceneE, i24 0, i32 7), align 1, !tbaa !91
  %766 = icmp ugt i16 %760, 90
  br i1 %766, label %767, label %769

767:                                              ; preds = %762
  %768 = sdiv i24 %764, 3
  br label %773

769:                                              ; preds = %762
  %770 = sub nsw i24 90, %763
  %771 = sdiv i24 %770, -5
  %772 = add nsw i24 %771, 20
  br label %773

773:                                              ; preds = %769, %767
  %774 = phi i24 [ %768, %767 ], [ %772, %769 ]
  %775 = call i24 @llvm.smax.i24(i24 %774, i24 -4)
  %776 = add nsw i24 %775, 8
  %777 = sdiv i24 %764, 8
  %778 = sdiv i24 %764, 6
  br label %779

779:                                              ; preds = %785, %773
  %780 = phi i24 [ 0, %773 ], [ %810, %785 ]
  %781 = icmp eq i24 %780, 8
  br i1 %781, label %782, label %785

782:                                              ; preds = %779
  %783 = add nsw i24 %765, -6
  %784 = add nsw i24 %765, 6
  call void @_ZN5rally6Stream4rectEiiiii(ptr noundef nonnull align 1 dereferenceable(4100) @_ZN12_GLOBAL__N_16streamE, i24 noundef %783, i24 noundef 187, i24 noundef %784, i24 noundef 199, i24 noundef 15) #18
  call fastcc void @_ZN12_GLOBAL__N_15flushEv() #18
  br label %824

785:                                              ; preds = %779
  %786 = getelementptr inbounds [8 x i24], ptr @__const._ZN12_GLOBAL__N_110drawPlayerEv.dx, i24 0, i24 %780
  %787 = load i24, ptr %786, align 1, !tbaa !92
  %788 = mul nsw i24 %787, %776
  %789 = sdiv i24 %788, 10
  %790 = add nsw i24 %789, %765
  %791 = getelementptr inbounds [8 x i24], ptr @__const._ZN12_GLOBAL__N_110drawPlayerEv.dy, i24 0, i24 %780
  %792 = load i24, ptr %791, align 1, !tbaa !92
  %793 = mul nsw i24 %792, %776
  %794 = sdiv i24 %793, 10
  %795 = add nsw i24 %794, 193
  %796 = add nsw i24 %780, %777
  %797 = srem i24 %796, 6
  %798 = add nsw i24 %797, 3
  %799 = sub nsw i24 %790, %798
  %800 = sub nsw i24 %795, %798
  %801 = add nsw i24 %790, %798
  %802 = add nsw i24 %795, %798
  %803 = add nsw i24 %780, %778
  %804 = urem i24 %803, 3
  %805 = icmp eq i24 %804, 0
  %806 = and i24 %780, 1
  %807 = icmp eq i24 %806, 0
  %808 = select i1 %807, i24 9, i24 11
  %809 = select i1 %805, i24 15, i24 %808
  call void @_ZN5rally6Stream4rectEiiiii(ptr noundef nonnull align 1 dereferenceable(4100) @_ZN12_GLOBAL__N_16streamE, i24 noundef %799, i24 noundef %800, i24 noundef %801, i24 noundef %802, i24 noundef %809) #18
  %810 = add nuw nsw i24 %780, 1
  br label %779, !llvm.loop !93

811:                                              ; preds = %759
  %812 = load i16, ptr getelementptr inbounds (%"struct.rally::game::Crash", ptr @_ZN12_GLOBAL__N_15crashE, i24 0, i32 1), align 1, !tbaa !94
  %813 = icmp eq i16 %812, 0
  br i1 %813, label %818, label %814

814:                                              ; preds = %811
  %815 = udiv i16 %812, 10
  %816 = and i16 %815, 1
  %817 = icmp eq i16 %816, 0
  br i1 %817, label %818, label %824

818:                                              ; preds = %814, %811
  %819 = load i24, ptr getelementptr inbounds (%"struct.rally::r18::SceneState", ptr @_ZN12_GLOBAL__N_15sceneE, i24 0, i32 5), align 1, !tbaa !95
  call void @vdp_select_bitmap(i24 noundef %819) #17
  %820 = load i8, ptr getelementptr inbounds (%"struct.rally::r18::SceneState", ptr @_ZN12_GLOBAL__N_15sceneE, i24 0, i32 8), align 1, !tbaa !96, !range !34
  %821 = icmp eq i8 %820, 0
  %822 = select i1 %821, i16 -1, i16 -1552
  call void @vdp_adv_use_affine_matrix(i8 noundef 1, i16 noundef %822) #17
  %823 = load i24, ptr getelementptr inbounds (%"struct.rally::r18::SceneState", ptr @_ZN12_GLOBAL__N_15sceneE, i24 0, i32 6), align 1, !tbaa !97
  call void @vdp_draw_bitmap(i24 noundef %823, i24 noundef 154) #17
  call void @vdp_adv_use_affine_matrix(i8 noundef 1, i16 noundef -1) #17
  br label %824

824:                                              ; preds = %782, %814, %818
  call void @_ZN5rally4game8viewportERNS_6StreamEiiii(ptr noundef nonnull align 1 dereferenceable(4100) @_ZN12_GLOBAL__N_16streamE, i24 noundef 0, i24 noundef 0, i24 noundef 319, i24 noundef 239) #18
  call fastcc void @_ZN12_GLOBAL__N_15flushEv() #18
  %825 = load i8, ptr getelementptr inbounds (%"struct.rally::game::Rules", ptr @_ZN12_GLOBAL__N_15rulesE, i24 0, i32 2), align 1, !tbaa !36
  switch i8 %825, label %826 [
    i8 6, label %877
    i8 3, label %877
  ]

826:                                              ; preds = %824
  call void @llvm.lifetime.start.p0(i64 160, ptr nonnull %7) #19
  %827 = load i32, ptr getelementptr inbounds (%"struct.rally::game::Rules", ptr @_ZN12_GLOBAL__N_15rulesE, i24 0, i32 3), align 1, !tbaa !37
  %828 = sub i32 479, %827
  %829 = udiv i32 %828, 120
  %830 = trunc i32 %829 to i24
  %831 = zext i8 %825 to i24
  %832 = load ptr, ptr @_ZN12_GLOBAL__N_18selectedE, align 1, !tbaa !11
  %833 = icmp eq ptr %832, @_ZN5rallyL4FujiE
  %834 = select i1 %833, ptr @.str.21, ptr @.str.22
  %835 = load i8, ptr getelementptr inbounds (%"struct.rally::game::Rules", ptr @_ZN12_GLOBAL__N_15rulesE, i24 0, i32 1), align 1, !tbaa !13
  %836 = zext i8 %835 to i24
  %837 = icmp eq i8 %825, 2
  %838 = icmp eq i8 %825, 5
  %839 = or i1 %837, %838
  %840 = select i1 %839, i24 %830, i24 0
  %841 = load i8, ptr getelementptr inbounds (%"struct.rally::game::Rules", ptr @_ZN12_GLOBAL__N_15rulesE, i24 0, i32 17), align 1, !tbaa !98
  %842 = zext i8 %841 to i24
  %843 = call i24 (ptr, i24, ptr, ...) @snprintf(ptr noundef nonnull %7, i24 noundef 160, ptr noundef nonnull @.str.20, i24 noundef %831, ptr noundef nonnull %834, i24 noundef %836, i24 noundef %840, i24 noundef %842) #17
  %844 = load i24, ptr getelementptr inbounds (%"struct.rally::SceneryHistory", ptr @_ZN12_GLOBAL__N_114sceneryHistoryE, i24 0, i32 2), align 1, !tbaa !99
  %845 = getelementptr inbounds [2 x [160 x i8]], ptr @_ZN12_GLOBAL__N_110panelCacheE, i24 0, i24 %844
  %846 = call i24 @strcmp(ptr noundef nonnull %845, ptr noundef nonnull %7) #17
  %847 = icmp eq i24 %846, 0
  br i1 %847, label %876, label %848

848:                                              ; preds = %826
  %849 = load i24, ptr getelementptr inbounds (%"struct.rally::SceneryHistory", ptr @_ZN12_GLOBAL__N_114sceneryHistoryE, i24 0, i32 2), align 1, !tbaa !99
  %850 = getelementptr inbounds [2 x [160 x i8]], ptr @_ZN12_GLOBAL__N_110panelCacheE, i24 0, i24 %849
  %851 = call ptr @strcpy(ptr noundef nonnull %850, ptr noundef nonnull %7) #18
  call void @_ZN5rally6Stream4rectEiiiii(ptr noundef nonnull align 1 dereferenceable(4100) @_ZN12_GLOBAL__N_16streamE, i24 noundef 0, i24 noundef 24, i24 noundef 319, i24 noundef 87, i24 noundef 20) #18
  call fastcc void @_ZN12_GLOBAL__N_15flushEv() #18
  %852 = load i8, ptr getelementptr inbounds (%"struct.rally::game::Rules", ptr @_ZN12_GLOBAL__N_15rulesE, i24 0, i32 2), align 1, !tbaa !36
  switch i8 %852, label %876 [
    i8 0, label %853
    i8 1, label %854
    i8 2, label %861
    i8 5, label %861
    i8 4, label %865
    i8 7, label %869
    i8 8, label %869
    i8 9, label %869
  ]

853:                                              ; preds = %848
  call fastcc void @_ZN12_GLOBAL__N_14fontEj(i24 noundef 63941) #18
  call fastcc void @_ZN12_GLOBAL__N_14textEiiPKcii(i24 noundef 5, i24 noundef 2, ptr noundef nonnull @.str.23, i24 noundef 11, i24 noundef 20) #18
  call fastcc void @_ZN12_GLOBAL__N_14fontEj(i24 noundef 63940) #18
  call fastcc void @_ZN12_GLOBAL__N_16centreEiPKci(i24 noundef 7, ptr noundef nonnull @.str.24, i24 noundef 15) #18
  call fastcc void @_ZN12_GLOBAL__N_16centreEiPKci(i24 noundef 9, ptr noundef nonnull @.str.25, i24 noundef 11) #18
  br label %876

854:                                              ; preds = %848
  call fastcc void @_ZN12_GLOBAL__N_16centreEiPKci(i24 noundef 4, ptr noundef nonnull @.str.26, i24 noundef 11) #18
  %855 = load ptr, ptr @_ZN12_GLOBAL__N_18selectedE, align 1, !tbaa !11
  %856 = icmp eq ptr %855, @_ZN5rallyL4FujiE
  %857 = select i1 %856, ptr @.str.27, ptr @.str.28
  call fastcc void @_ZN12_GLOBAL__N_16centreEiPKci(i24 noundef 6, ptr noundef nonnull %857, i24 noundef 15) #18
  %858 = load i8, ptr getelementptr inbounds (%"struct.rally::game::Rules", ptr @_ZN12_GLOBAL__N_15rulesE, i24 0, i32 1), align 1, !tbaa !13
  %859 = icmp eq i8 %858, 0
  %860 = select i1 %859, ptr @.str.29, ptr @.str.30
  call fastcc void @_ZN12_GLOBAL__N_16centreEiPKci(i24 noundef 8, ptr noundef nonnull %860, i24 noundef 15) #18
  call fastcc void @_ZN12_GLOBAL__N_16centreEiPKci(i24 noundef 10, ptr noundef nonnull @.str.31, i24 noundef 11) #18
  br label %876

861:                                              ; preds = %848, %848
  %862 = icmp eq i8 %852, 2
  %863 = select i1 %862, ptr @.str.32, ptr @.str.33
  call fastcc void @_ZN12_GLOBAL__N_16centreEiPKci(i24 noundef 4, ptr noundef nonnull %863, i24 noundef 11) #18
  %864 = call i24 (ptr, i24, ptr, ...) @snprintf(ptr noundef nonnull %7, i24 noundef 160, ptr noundef nonnull @.str.34, i24 noundef %830) #17
  call fastcc void @_ZN12_GLOBAL__N_14fontEj(i24 noundef 63941) #18
  call fastcc void @_ZN12_GLOBAL__N_14textEiiPKcii(i24 noundef 9, i24 noundef 3, ptr noundef nonnull %7, i24 noundef 15, i24 noundef 20) #18
  call fastcc void @_ZN12_GLOBAL__N_14fontEj(i24 noundef 63940) #18
  call fastcc void @_ZN12_GLOBAL__N_16centreEiPKci(i24 noundef 10, ptr noundef nonnull @.str.35, i24 noundef 15) #18
  br label %876

865:                                              ; preds = %848
  call fastcc void @_ZN12_GLOBAL__N_16centreEiPKci(i24 noundef 4, ptr noundef nonnull @.str.36, i24 noundef 11) #18
  %866 = load i8, ptr getelementptr inbounds (%"struct.rally::game::Rules", ptr @_ZN12_GLOBAL__N_15rulesE, i24 0, i32 17), align 1, !tbaa !98
  %867 = zext i8 %866 to i24
  %868 = call i24 (ptr, i24, ptr, ...) @snprintf(ptr noundef nonnull %7, i24 noundef 160, ptr noundef nonnull @.str.37, i24 noundef %867) #17
  call fastcc void @_ZN12_GLOBAL__N_16centreEiPKci(i24 noundef 7, ptr noundef nonnull %7, i24 noundef 15) #18
  call fastcc void @_ZN12_GLOBAL__N_16centreEiPKci(i24 noundef 9, ptr noundef nonnull @.str.38, i24 noundef 15) #18
  br label %876

869:                                              ; preds = %848, %848, %848
  %870 = icmp eq i8 %852, 7
  %871 = icmp eq i8 %852, 8
  %872 = select i1 %871, ptr @.str.40, ptr @.str.41
  %873 = select i1 %870, ptr @.str.39, ptr %872
  call fastcc void @_ZN12_GLOBAL__N_16centreEiPKci(i24 noundef 4, ptr noundef nonnull %873, i24 noundef 11) #18
  call void @llvm.lifetime.start.p0(i64 20, ptr nonnull %8) #19
  %874 = load i32, ptr getelementptr inbounds (%"struct.rally::game::Rules", ptr @_ZN12_GLOBAL__N_15rulesE, i24 0, i32 8), align 1, !tbaa !101
  call fastcc void @_ZN12_GLOBAL__N_19clockTextEPcjm(ptr noundef nonnull %8, i32 noundef %874) #18
  %875 = call i24 (ptr, i24, ptr, ...) @snprintf(ptr noundef nonnull %7, i24 noundef 160, ptr noundef nonnull @.str.42, ptr noundef nonnull %8) #17
  call fastcc void @_ZN12_GLOBAL__N_16centreEiPKci(i24 noundef 6, ptr noundef nonnull %7, i24 noundef 15) #18
  call void @llvm.lifetime.end.p0(i64 20, ptr nonnull %8) #19
  call fastcc void @_ZN12_GLOBAL__N_16centreEiPKci(i24 noundef 8, ptr noundef nonnull @.str.43, i24 noundef 15) #18
  call fastcc void @_ZN12_GLOBAL__N_16centreEiPKci(i24 noundef 10, ptr noundef nonnull @.str.44, i24 noundef 14) #18
  br label %876

876:                                              ; preds = %869, %865, %861, %854, %853, %848, %826
  call void @llvm.lifetime.end.p0(i64 160, ptr nonnull %7) #19
  br label %877

877:                                              ; preds = %824, %824, %876
  call void @llvm.lifetime.start.p0(i64 240, ptr nonnull %4) #19
  call void @_ZN5rally4game8HudImageC2Ev(ptr noundef nonnull align 1 dereferenceable(240) %4) #18
  call void @llvm.lifetime.start.p0(i64 48, ptr nonnull %5) #19
  call void @llvm.lifetime.start.p0(i64 20, ptr nonnull %6) #19
  %878 = load i8, ptr getelementptr inbounds (%"struct.rally::game::Rules", ptr @_ZN12_GLOBAL__N_15rulesE, i24 0, i32 2), align 1, !tbaa !36
  switch i8 %878, label %879 [
    i8 6, label %884
    i8 3, label %884
  ]

879:                                              ; preds = %877
  %880 = add i8 %878, -7
  %881 = icmp ult i8 %880, 3
  %882 = icmp eq i8 %878, 4
  %883 = or i1 %882, %881
  br label %884

884:                                              ; preds = %879, %877, %877
  %885 = phi i1 [ true, %877 ], [ true, %877 ], [ %883, %879 ]
  %886 = load ptr, ptr @_ZN12_GLOBAL__N_18selectedE, align 1, !tbaa !11
  %887 = icmp eq ptr %886, @_ZN5rallyL4FujiE
  %888 = load i8, ptr getelementptr inbounds (%"struct.rally::game::Rules", ptr @_ZN12_GLOBAL__N_15rulesE, i24 0, i32 1), align 1, !tbaa !13
  %889 = icmp eq i8 %888, 1
  %890 = load i1, ptr @_ZN12_GLOBAL__N_112steeringStepE, align 1
  %891 = select i1 %890, i24 1, i24 2
  %892 = load i24, ptr getelementptr inbounds (%"struct.rally::game::Rules", ptr @_ZN12_GLOBAL__N_15rulesE, i24 0, i32 19), align 1
  %893 = load i24, ptr getelementptr inbounds (%"struct.rally::Motion", ptr @_ZN12_GLOBAL__N_16motionE, i24 0, i32 8), align 1
  %894 = select i1 %885, i24 %892, i24 %893
  %895 = select i1 %887, i24 2, i24 0
  %896 = zext i1 %889 to i24
  %897 = or i24 %895, %896
  %898 = shl nuw nsw i24 %897, 1
  %899 = add nuw nsw i24 %898, %891
  %900 = mul nuw nsw i24 %899, 36
  %901 = add nsw i24 %894, -25
  %902 = sdiv i24 %901, 5
  %903 = add nsw i24 %902, -36
  %904 = add nsw i24 %903, %900
  %905 = getelementptr inbounds [288 x %"struct.rally::game::Record"], ptr @_ZN12_GLOBAL__N_17recordsE, i24 0, i24 %904
  %906 = load i32, ptr %905, align 1, !tbaa !102
  %907 = call i24 (ptr, i24, ptr, ...) @snprintf(ptr noundef nonnull %5, i24 noundef 48, ptr noundef nonnull @.str.46, i32 noundef %906) #17
  call void @_ZN5rally4game8HudImage3putEjjPKch(ptr noundef nonnull align 1 dereferenceable(240) %4, i24 noundef 0, i24 noundef 0, ptr noundef nonnull %5, i8 noundef 11) #18
  %908 = load i32, ptr getelementptr inbounds (%"struct.rally::game::Rules", ptr @_ZN12_GLOBAL__N_15rulesE, i24 0, i32 5), align 1, !tbaa !104
  %909 = add i32 %908, 119
  %910 = udiv i32 %909, 120
  %911 = call i24 (ptr, i24, ptr, ...) @snprintf(ptr noundef nonnull %5, i24 noundef 48, ptr noundef nonnull @.str.47, i32 noundef %910) #17
  call void @_ZN5rally4game8HudImage3putEjjPKch(ptr noundef nonnull align 1 dereferenceable(240) %4, i24 noundef 14, i24 noundef 0, ptr noundef nonnull %5, i8 noundef 11) #18
  %912 = load i8, ptr getelementptr inbounds (%"struct.rally::game::Rules", ptr @_ZN12_GLOBAL__N_15rulesE, i24 0, i32 2), align 1, !tbaa !36
  switch i8 %912, label %917 [
    i8 6, label %913
    i8 3, label %913
  ]

913:                                              ; preds = %884, %884
  %914 = load i32, ptr getelementptr inbounds (%"struct.rally::game::Rules", ptr @_ZN12_GLOBAL__N_15rulesE, i24 0, i32 4), align 1, !tbaa !59
  %915 = load i32, ptr getelementptr inbounds (%"struct.rally::game::Rules", ptr @_ZN12_GLOBAL__N_15rulesE, i24 0, i32 6), align 1, !tbaa !105
  %916 = sub i32 %914, %915
  br label %919

917:                                              ; preds = %884
  %918 = load i32, ptr getelementptr inbounds (%"struct.rally::game::Rules", ptr @_ZN12_GLOBAL__N_15rulesE, i24 0, i32 7), align 1, !tbaa !106
  br label %919

919:                                              ; preds = %917, %913
  %920 = phi i32 [ %916, %913 ], [ %918, %917 ]
  call fastcc void @_ZN12_GLOBAL__N_19clockTextEPcjm(ptr noundef nonnull %6, i32 noundef %920) #18
  %921 = call i24 (ptr, i24, ptr, ...) @snprintf(ptr noundef nonnull %5, i24 noundef 48, ptr noundef nonnull @.str.48, ptr noundef nonnull %6) #17
  call void @_ZN5rally4game8HudImage3putEjjPKch(ptr noundef nonnull align 1 dereferenceable(240) %4, i24 noundef 25, i24 noundef 0, ptr noundef nonnull %5, i8 noundef 15) #18
  %922 = load i32, ptr getelementptr inbounds (%"struct.rally::game::Rules", ptr @_ZN12_GLOBAL__N_15rulesE, i24 0, i32 10), align 1, !tbaa !64
  %923 = call i24 (ptr, i24, ptr, ...) @snprintf(ptr noundef nonnull %5, i24 noundef 48, ptr noundef nonnull @.str.49, i32 noundef %922) #17
  call void @_ZN5rally4game8HudImage3putEjjPKch(ptr noundef nonnull align 1 dereferenceable(240) %4, i24 noundef 0, i24 noundef 1, ptr noundef nonnull %5, i8 noundef 15) #18
  %924 = load i32, ptr getelementptr inbounds (%"struct.rally::Motion", ptr @_ZN12_GLOBAL__N_16motionE, i24 0, i32 3), align 1, !tbaa !44
  %925 = call i24 (ptr, i24, ptr, ...) @snprintf(ptr noundef nonnull %5, i24 noundef 48, ptr noundef nonnull @.str.50, i32 noundef %924) #17
  call void @_ZN5rally4game8HudImage3putEjjPKch(ptr noundef nonnull align 1 dereferenceable(240) %4, i24 noundef 16, i24 noundef 1, ptr noundef nonnull %5, i8 noundef 15) #18
  %926 = load i8, ptr getelementptr inbounds (%"struct.rally::game::Rules", ptr @_ZN12_GLOBAL__N_15rulesE, i24 0, i32 1), align 1, !tbaa !13
  %927 = icmp eq i8 %926, 0
  br i1 %927, label %928, label %936

928:                                              ; preds = %919
  %929 = load i8, ptr getelementptr inbounds (%"struct.rally::game::Rules", ptr @_ZN12_GLOBAL__N_15rulesE, i24 0, i32 2), align 1, !tbaa !36
  %930 = add i8 %929, -6
  %931 = icmp ult i8 %930, 3
  br i1 %931, label %932, label %936

932:                                              ; preds = %928
  %933 = load i8, ptr getelementptr inbounds (%"struct.rally::game::Rules", ptr @_ZN12_GLOBAL__N_15rulesE, i24 0, i32 18), align 1, !tbaa !66
  %934 = zext i8 %933 to i24
  %935 = call i24 (ptr, i24, ptr, ...) @snprintf(ptr noundef nonnull %5, i24 noundef 48, ptr noundef nonnull @.str.51, i24 noundef %934) #17
  call void @_ZN5rally4game8HudImage3putEjjPKch(ptr noundef nonnull align 1 dereferenceable(240) %4, i24 noundef 30, i24 noundef 1, ptr noundef nonnull %5, i8 noundef 11) #18
  br label %936

936:                                              ; preds = %919, %928, %932
  %937 = load i24, ptr getelementptr inbounds (%"struct.rally::SceneryHistory", ptr @_ZN12_GLOBAL__N_114sceneryHistoryE, i24 0, i32 2), align 1, !tbaa !99
  call void @_ZN5rally4game3Hud4emitERNS_6StreamEjRKNS0_8HudImageE(ptr noundef nonnull align 1 dereferenceable(482) @_ZN12_GLOBAL__N_13hudE, ptr noundef nonnull align 1 dereferenceable(4100) @_ZN12_GLOBAL__N_16streamE, i24 noundef %937, ptr noundef nonnull align 1 dereferenceable(240) %4) #18
  call fastcc void @_ZN12_GLOBAL__N_15flushEv() #18
  call void @llvm.lifetime.end.p0(i64 20, ptr nonnull %6) #19
  call void @llvm.lifetime.end.p0(i64 48, ptr nonnull %5) #19
  call void @llvm.lifetime.end.p0(i64 240, ptr nonnull %4) #19
  %938 = load i8, ptr getelementptr inbounds (%"struct.rally::game::Rules", ptr @_ZN12_GLOBAL__N_15rulesE, i24 0, i32 2), align 1, !tbaa !36
  switch i8 %938, label %955 [
    i8 0, label %939
    i8 3, label %940
    i8 6, label %941
  ]

939:                                              ; preds = %936
  call fastcc void @_ZN12_GLOBAL__N_14textEiiPKcii(i24 noundef 2, i24 noundef 28, ptr noundef nonnull @.str.52, i24 noundef 15, i24 noundef 0) #18
  br label %955

940:                                              ; preds = %936
  call fastcc void @_ZN12_GLOBAL__N_14textEiiPKcii(i24 noundef 1, i24 noundef 28, ptr noundef nonnull @.str.53, i24 noundef 11, i24 noundef 0) #18
  br label %955

941:                                              ; preds = %936
  call void @llvm.lifetime.start.p0(i64 40, ptr nonnull %3) #19
  %942 = load i8, ptr getelementptr inbounds (%"struct.rally::game::Rules", ptr @_ZN12_GLOBAL__N_15rulesE, i24 0, i32 1), align 1, !tbaa !13
  %943 = icmp eq i8 %942, 0
  %944 = select i1 %943, ptr @.str.55, ptr @.str.56
  %945 = load i8, ptr getelementptr inbounds (%"struct.rally::game::Rules", ptr @_ZN12_GLOBAL__N_15rulesE, i24 0, i32 16), align 1, !tbaa !107
  %946 = zext i8 %945 to i24
  %947 = add nuw nsw i24 %946, 1
  %948 = load i8, ptr getelementptr inbounds (%"struct.rally::game::Rules", ptr @_ZN12_GLOBAL__N_15rulesE, i24 0, i32 0, i32 4), align 1, !tbaa !108
  %949 = zext i8 %948 to i24
  %950 = call i24 (ptr, i24, ptr, ...) @snprintf(ptr noundef nonnull %3, i24 noundef 40, ptr noundef nonnull @.str.54, ptr noundef nonnull %944, i24 noundef %947, i24 noundef %949) #17
  call fastcc void @_ZN12_GLOBAL__N_14textEiiPKcii(i24 noundef 1, i24 noundef 28, ptr noundef nonnull %3, i24 noundef 15, i24 noundef 0) #18
  %951 = load i16, ptr getelementptr inbounds (%"struct.rally::game::Rules", ptr @_ZN12_GLOBAL__N_15rulesE, i24 0, i32 15), align 1, !tbaa !109
  %952 = icmp eq i16 %951, 0
  br i1 %952, label %954, label %953

953:                                              ; preds = %941
  call fastcc void @_ZN12_GLOBAL__N_14textEiiPKcii(i24 noundef 23, i24 noundef 28, ptr noundef nonnull @.str.57, i24 noundef 11, i24 noundef 0) #18
  br label %954

954:                                              ; preds = %953, %941
  call void @llvm.lifetime.end.p0(i64 40, ptr nonnull %3) #19
  br label %955

955:                                              ; preds = %936, %939, %940, %954
  call void @vdp_swap() #17
  %956 = load i24, ptr getelementptr inbounds (%"struct.rally::SceneryHistory", ptr @_ZN12_GLOBAL__N_114sceneryHistoryE, i24 0, i32 2), align 1, !tbaa !99
  %957 = xor i24 %956, 1
  store i24 %957, ptr getelementptr inbounds (%"struct.rally::SceneryHistory", ptr @_ZN12_GLOBAL__N_114sceneryHistoryE, i24 0, i32 2), align 1, !tbaa !99
  %958 = load i8, ptr @_ZN12_GLOBAL__N_111savePendingE, align 1, !tbaa !12, !range !34
  %959 = icmp eq i8 %958, 0
  br i1 %959, label %967, label %960

960:                                              ; preds = %955
  %961 = load i8, ptr getelementptr inbounds (%"struct.rally::game::Rules", ptr @_ZN12_GLOBAL__N_15rulesE, i24 0, i32 2), align 1, !tbaa !36
  %962 = add i8 %961, -7
  %963 = icmp ult i8 %962, 3
  br i1 %963, label %964, label %967

964:                                              ; preds = %960
  %965 = call noundef i1 @_ZN5rally4game11saveRecordsERKNS0_7RecordsE(ptr noundef nonnull align 1 dereferenceable(2304) @_ZN12_GLOBAL__N_17recordsE) #18
  store i8 0, ptr @_ZN12_GLOBAL__N_111savePendingE, align 1, !tbaa !12
  %966 = call fastcc noundef i32 @_ZN12_GLOBAL__N_18rawClockEv() #18
  br label %967

967:                                              ; preds = %964, %960, %955
  %968 = phi i32 [ %294, %955 ], [ %294, %960 ], [ %966, %964 ]
  %969 = add i32 %968, 4
  br label %288

970:                                              ; preds = %291, %428, %333
  call void @_ZN5rally4game6Engine4stopIPFvPKhjEEEvT_(ptr noundef nonnull align 1 dereferenceable(4) @_ZN12_GLOBAL__N_16engineE, ptr noundef nonnull @_ZN12_GLOBAL__N_14sendEPKhj) #18
  call fastcc void @_ZN12_GLOBAL__N_14fontEj(i24 noundef 65535) #18
  %971 = getelementptr inbounds i8, ptr %15, i24 1
  %972 = getelementptr inbounds i8, ptr %15, i24 2
  %973 = getelementptr inbounds i8, ptr %15, i24 3
  %974 = getelementptr inbounds i8, ptr %15, i24 4
  %975 = getelementptr inbounds i8, ptr %15, i24 5
  br label %976

976:                                              ; preds = %981, %970
  %977 = phi i24 [ 0, %970 ], [ %987, %981 ]
  %978 = icmp eq i24 %977, 2
  br i1 %978, label %979, label %981

979:                                              ; preds = %976
  %980 = call i24 @vdp_mode(i24 noundef 0) #17
  call void @vdp_set_logical_coordinates() #17
  call void @vdp_cursor_enable(i1 noundef true) #17
  br label %988

981:                                              ; preds = %976
  %982 = getelementptr inbounds i24, ptr @__const._Z8gameMainiPPc.fonts, i24 %977
  %983 = load i24, ptr %982, align 1, !tbaa !92
  call void @llvm.lifetime.start.p0(i64 6, ptr nonnull %15) #19
  store i8 23, ptr %15, align 1, !tbaa !22
  store i8 0, ptr %971, align 1, !tbaa !22
  store i8 -107, ptr %972, align 1, !tbaa !22
  store i8 4, ptr %973, align 1, !tbaa !22
  %984 = trunc i24 %983 to i8
  store i8 %984, ptr %974, align 1, !tbaa !22
  %985 = lshr i24 %983, 8
  %986 = trunc i24 %985 to i8
  store i8 %986, ptr %975, align 1, !tbaa !22
  call void @_ZN12_GLOBAL__N_14sendEPKhj(ptr noundef nonnull %15, i24 noundef 6) #18
  call void @vdp_adv_clear_buffer(i24 noundef %983) #17
  call void @llvm.lifetime.end.p0(i64 6, ptr nonnull %15) #19
  %987 = add nuw nsw i24 %977, 1
  br label %976

988:                                              ; preds = %62, %68, %979
  %989 = phi i24 [ 1, %62 ], [ 0, %979 ], [ 1, %68 ]
  ret i24 %989
}

; Function Attrs: argmemonly mustprogress nocallback nofree nosync nounwind willreturn
declare void @llvm.lifetime.start.p0(i64 immarg, ptr nocapture) #1

; Function Attrs: minsize optsize
declare dso_local i24 @strcmp(ptr noundef, ptr noundef) local_unnamed_addr #2

; Function Attrs: argmemonly mustprogress nocallback nofree nosync nounwind willreturn
declare void @llvm.lifetime.end.p0(i64 immarg, ptr nocapture) #1

; Function Attrs: inlinehint minsize mustprogress nounwind optsize
define linkonce_odr dso_local noundef i1 @_ZN5rally4game11readRecordsEPKcRNS0_7RecordsE(ptr noundef %0, ptr noundef nonnull align 1 dereferenceable(2304) %1) local_unnamed_addr #3 {
  %3 = alloca [2320 x i8], align 1
  %4 = tail call ptr @fopen(ptr noundef %0, ptr noundef nonnull @.str.15) #18
  %5 = icmp eq ptr %4, null
  br i1 %5, label %19, label %6

6:                                                ; preds = %2
  call void @llvm.lifetime.start.p0(i64 2320, ptr nonnull %3) #19
  %7 = call i24 @fread(ptr noundef nonnull %3, i24 noundef 1, i24 noundef 2320, ptr noundef nonnull %4) #18
  %8 = icmp eq i24 %7, 2320
  br i1 %8, label %9, label %15

9:                                                ; preds = %6
  %10 = tail call i24 @fgetc(ptr noundef nonnull %4) #18
  %11 = icmp eq i24 %10, -1
  %12 = tail call i24 @fclose(ptr noundef nonnull %4) #18
  br i1 %11, label %13, label %17

13:                                               ; preds = %9
  %14 = call noundef i1 @_ZN5rally4game7Records6decodeEPKhj(ptr noundef nonnull align 1 dereferenceable(2304) %1, ptr noundef nonnull %3, i24 noundef 2320) #18
  br label %17

15:                                               ; preds = %6
  %16 = tail call i24 @fclose(ptr noundef nonnull %4) #18
  br label %17

17:                                               ; preds = %15, %13, %9
  %18 = phi i1 [ false, %9 ], [ %14, %13 ], [ false, %15 ]
  call void @llvm.lifetime.end.p0(i64 2320, ptr nonnull %3) #19
  br label %19

19:                                               ; preds = %2, %17
  %20 = phi i1 [ %18, %17 ], [ false, %2 ]
  ret i1 %20
}

; Function Attrs: minsize mustprogress nounwind optsize
define internal fastcc void @_ZN12_GLOBAL__N_19loadTrackEv() unnamed_addr #4 {
  %1 = load ptr, ptr @_ZN12_GLOBAL__N_18selectedE, align 1, !tbaa !11
  store ptr %1, ptr @_ZN12_GLOBAL__N_14roadE, align 1, !tbaa !110
  tail call void @_ZN5rally4Road4initEv(ptr noundef nonnull align 1 dereferenceable(2167) @_ZN12_GLOBAL__N_14roadE) #18
  ret void
}

; Function Attrs: minsize optsize
declare dso_local i24 @vdp_mode(i24 noundef) local_unnamed_addr #2

; Function Attrs: minsize optsize
declare dso_local void @vdp_set_pixel_coordinates() local_unnamed_addr #2

; Function Attrs: minsize optsize
declare dso_local void @vdp_reset_sprites() local_unnamed_addr #2

; Function Attrs: minsize optsize
declare dso_local void @vdp_cursor_enable(i1 noundef) local_unnamed_addr #2

; Function Attrs: minsize mustprogress nounwind optsize
define internal fastcc void @_ZN12_GLOBAL__N_111resetMotionEv() unnamed_addr #4 {
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 1 dereferenceable(24) getelementptr inbounds (%"struct.rally::Motion", ptr @_ZN12_GLOBAL__N_16motionE, i24 0, i32 1), i8 0, i64 24, i1 false)
  store i8 1, ptr getelementptr inbounds (%"struct.rally::Motion", ptr @_ZN12_GLOBAL__N_16motionE, i24 0, i32 9), align 1, !tbaa.struct !112
  %1 = load ptr, ptr @_ZN12_GLOBAL__N_18selectedE, align 1, !tbaa !11
  store ptr %1, ptr @_ZN12_GLOBAL__N_16motionE, align 1, !tbaa !113
  %2 = getelementptr inbounds %"struct.rally::TrackDef", ptr %1, i24 0, i32 2
  %3 = load i32, ptr %2, align 1, !tbaa !39
  %4 = mul nsw i32 %3, 100
  %5 = add nsw i32 %4, -6800
  store i32 %5, ptr getelementptr inbounds (%"struct.rally::Motion", ptr @_ZN12_GLOBAL__N_16motionE, i24 0, i32 2), align 1, !tbaa !53
  store i8 0, ptr getelementptr inbounds (%"struct.rally::Motion", ptr @_ZN12_GLOBAL__N_16motionE, i24 0, i32 9), align 1, !tbaa !45
  store i16 0, ptr @_ZN12_GLOBAL__N_15crashE, align 1, !tbaa.struct !114
  store i16 0, ptr getelementptr inbounds (%"struct.rally::game::Crash", ptr @_ZN12_GLOBAL__N_15crashE, i24 0, i32 1), align 1, !tbaa.struct !115
  store i32 0, ptr @_ZN12_GLOBAL__N_115attractProgressE, align 1, !tbaa !46
  %6 = load i8, ptr getelementptr inbounds (%"struct.rally::game::Rules", ptr @_ZN12_GLOBAL__N_15rulesE, i24 0, i32 2), align 1, !tbaa !36
  %7 = icmp eq i8 %6, 0
  %8 = load i8, ptr getelementptr inbounds (%"struct.rally::game::Rules", ptr @_ZN12_GLOBAL__N_15rulesE, i24 0, i32 1), align 1
  %9 = load i8, ptr getelementptr inbounds (%"struct.rally::game::Rules", ptr @_ZN12_GLOBAL__N_15rulesE, i24 0, i32 17), align 1
  %10 = select i1 %7, i8 0, i8 %8
  %11 = select i1 %7, i8 7, i8 %9
  %12 = load i8, ptr getelementptr inbounds (%"struct.rally::game::Rules", ptr @_ZN12_GLOBAL__N_15rulesE, i24 0, i32 0, i32 4), align 1, !tbaa !108
  tail call void @_ZN5rally4game11RaceTraffic5resetENS0_6PolicyElhh(ptr noundef nonnull align 1 dereferenceable(197) @_ZN12_GLOBAL__N_111raceTrafficE, i8 noundef %10, i32 noundef %4, i8 noundef %11, i8 noundef %12) #18
  %13 = load i32, ptr getelementptr inbounds (%"struct.rally::Motion", ptr @_ZN12_GLOBAL__N_16motionE, i24 0, i32 2), align 1, !tbaa !53
  tail call void @_ZNK5rally4game11RaceTraffic4viewERNS_7TrafficEl(ptr noundef nonnull align 1 dereferenceable(197) @_ZN12_GLOBAL__N_111raceTrafficE, ptr noundef nonnull align 1 dereferenceable(60) @_ZN12_GLOBAL__N_17trafficE, i32 noundef %13) #18
  ret void
}

; Function Attrs: minsize mustprogress nounwind optsize
define internal fastcc void @_ZN12_GLOBAL__N_112phaseChangedEv() unnamed_addr #4 {
  %1 = load i16, ptr @_ZN12_GLOBAL__N_113shownRevisionE, align 1, !tbaa !57
  %2 = load i16, ptr getelementptr inbounds (%"struct.rally::game::Rules", ptr @_ZN12_GLOBAL__N_15rulesE, i24 0, i32 14), align 1, !tbaa !38
  %3 = icmp eq i16 %1, %2
  br i1 %3, label %54, label %4

4:                                                ; preds = %0
  store i16 %2, ptr @_ZN12_GLOBAL__N_113shownRevisionE, align 1, !tbaa !57
  store i8 0, ptr getelementptr inbounds (%"struct.rally::SceneryHistory", ptr @_ZN12_GLOBAL__N_114sceneryHistoryE, i24 0, i32 1, i24 1), align 1, !tbaa !12
  store i8 0, ptr getelementptr inbounds (%"struct.rally::SceneryHistory", ptr @_ZN12_GLOBAL__N_114sceneryHistoryE, i24 0, i32 1), align 1, !tbaa !12
  store i8 0, ptr getelementptr inbounds ([2 x [160 x i8]], ptr @_ZN12_GLOBAL__N_110panelCacheE, i24 0, i24 1), align 1, !tbaa !22
  store i8 0, ptr @_ZN12_GLOBAL__N_110panelCacheE, align 1, !tbaa !22
  %5 = load i8, ptr getelementptr inbounds (%"struct.rally::game::Rules", ptr @_ZN12_GLOBAL__N_15rulesE, i24 0, i32 2), align 1, !tbaa !36
  switch i8 %5, label %9 [
    i8 5, label %6
    i8 2, label %6
    i8 0, label %6
  ]

6:                                                ; preds = %4, %4, %4
  tail call fastcc void @_ZN12_GLOBAL__N_111resetMotionEv() #18
  %7 = load i8, ptr getelementptr inbounds (%"struct.rally::game::Rules", ptr @_ZN12_GLOBAL__N_15rulesE, i24 0, i32 2), align 1, !tbaa !36
  %8 = icmp eq i8 %7, 0
  br i1 %8, label %22, label %9

9:                                                ; preds = %4, %6
  %10 = phi i8 [ %7, %6 ], [ %5, %4 ]
  %11 = add i8 %10, -1
  %12 = icmp ult i8 %11, 9
  br i1 %12, label %13, label %24

13:                                               ; preds = %9
  %14 = zext i8 %11 to i16
  %15 = lshr i16 449, %14
  %16 = and i16 %15, 1
  %17 = icmp eq i16 %16, 0
  br i1 %17, label %24, label %18

18:                                               ; preds = %13
  %19 = sext i8 %11 to i24
  %20 = getelementptr inbounds [9 x i8], ptr @switch.table._ZN12_GLOBAL__N_112phaseChangedEv, i24 0, i24 %19
  %21 = load i8, ptr %20, align 1
  br label %22

22:                                               ; preds = %18, %6
  %23 = phi i8 [ 0, %6 ], [ %21, %18 ]
  store i1 false, ptr @_ZN12_GLOBAL__N_110inputArmedE, align 1
  br label %24

24:                                               ; preds = %13, %9, %22
  %25 = phi i8 [ %10, %9 ], [ %23, %22 ], [ %10, %13 ]
  %26 = add i8 %25, -7
  %27 = icmp ult i8 %26, 3
  br i1 %27, label %28, label %54

28:                                               ; preds = %24
  store i32 0, ptr getelementptr inbounds (%"struct.rally::Motion", ptr @_ZN12_GLOBAL__N_16motionE, i24 0, i32 3), align 1, !tbaa !44
  %29 = load ptr, ptr @_ZN12_GLOBAL__N_18selectedE, align 1, !tbaa !11
  %30 = icmp eq ptr %29, @_ZN5rallyL4FujiE
  %31 = load i8, ptr getelementptr inbounds (%"struct.rally::game::Rules", ptr @_ZN12_GLOBAL__N_15rulesE, i24 0, i32 1), align 1, !tbaa !13
  %32 = icmp eq i8 %31, 1
  %33 = load i1, ptr @_ZN12_GLOBAL__N_112steeringStepE, align 1
  %34 = select i1 %33, i24 1, i24 2
  %35 = load i24, ptr getelementptr inbounds (%"struct.rally::game::Rules", ptr @_ZN12_GLOBAL__N_15rulesE, i24 0, i32 19), align 1, !tbaa !42
  %36 = select i1 %30, i24 2, i24 0
  %37 = zext i1 %32 to i24
  %38 = or i24 %36, %37
  %39 = shl nuw nsw i24 %38, 1
  %40 = add nuw nsw i24 %39, %34
  %41 = mul nuw nsw i24 %40, 36
  %42 = add nsw i24 %35, -25
  %43 = sdiv i24 %42, 5
  %44 = add nsw i24 %43, -36
  %45 = add nsw i24 %44, %41
  %46 = load i32, ptr getelementptr inbounds (%"struct.rally::game::Rules", ptr @_ZN12_GLOBAL__N_15rulesE, i24 0, i32 10), align 1, !tbaa !64
  %47 = load i32, ptr getelementptr inbounds (%"struct.rally::game::Rules", ptr @_ZN12_GLOBAL__N_15rulesE, i24 0, i32 8), align 1, !tbaa !101
  %48 = tail call noundef i1 @_ZN5rally4game7Records6updateEjmm(ptr noundef nonnull align 1 dereferenceable(2304) @_ZN12_GLOBAL__N_17recordsE, i24 noundef %45, i32 noundef %46, i32 noundef %47) #18
  %49 = load i8, ptr @_ZN12_GLOBAL__N_111savePendingE, align 1
  %50 = and i8 %49, 1
  %51 = icmp ne i8 %50, 0
  %52 = select i1 %48, i1 true, i1 %51
  %53 = zext i1 %52 to i8
  store i8 %53, ptr @_ZN12_GLOBAL__N_111savePendingE, align 1, !tbaa !12
  br label %54

54:                                               ; preds = %0, %28, %24
  ret void
}

; Function Attrs: minsize mustprogress nounwind optsize
define linkonce_odr dso_local void @_ZN5rally4game6Engine5startIPFvPKhjEEEvT_(ptr noundef nonnull align 1 dereferenceable(4) %0, ptr noundef %1) local_unnamed_addr #4 align 2 {
  %3 = alloca [16 x i8], align 1
  %4 = alloca [6 x i8], align 1
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %3) #19
  call void @llvm.memcpy.p0.p0.i24(ptr noundef nonnull align 1 dereferenceable(16) %3, ptr noundef nonnull align 1 dereferenceable(16) @__const._ZN5rally4game6Engine5startIPFvPKhjEEEvT_.setup, i24 16, i1 false)
  call void %1(ptr noundef nonnull %3, i24 noundef 16) #17
  store i8 1, ptr %0, align 1, !tbaa !116
  %5 = getelementptr inbounds %"struct.rally::game::Engine", ptr %0, i24 0, i32 1
  store i24 0, ptr %5, align 1, !tbaa !118
  call void @_ZN5rally4game6Engine6updateIPFvPKhjEEEvlT_(ptr noundef nonnull align 1 dereferenceable(4) %0, i32 noundef 0, ptr noundef %1) #18
  call void @llvm.lifetime.start.p0(i64 6, ptr nonnull %4) #19
  call void @llvm.memcpy.p0.p0.i24(ptr noundef nonnull align 1 dereferenceable(6) %4, ptr noundef nonnull align 1 dereferenceable(6) @__const._ZN5rally4game6Engine5startIPFvPKhjEEEvT_.volume, i24 6, i1 false)
  call void %1(ptr noundef nonnull %4, i24 noundef 6) #17
  call void @llvm.lifetime.end.p0(i64 6, ptr nonnull %4) #19
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %3) #19
  ret void
}

; Function Attrs: minsize mustprogress nounwind optsize
define internal void @_ZN12_GLOBAL__N_14sendEPKhj(ptr noundef %0, i24 noundef %1) #4 {
  %3 = icmp eq i24 %1, 0
  br i1 %3, label %5, label %4

4:                                                ; preds = %2
  tail call void @mos_puts(ptr noundef %0, i24 noundef %1, i8 noundef 0) #17
  br label %5

5:                                                ; preds = %4, %2
  ret void
}

; Function Attrs: minsize mustprogress nofree norecurse nounwind optsize
define internal fastcc noundef i32 @_ZN12_GLOBAL__N_18rawClockEv() unnamed_addr #5 {
  %1 = load ptr, ptr @sys_vars, align 1, !tbaa !11
  br label %2

2:                                                ; preds = %2, %0
  %3 = load volatile i32, ptr %1, align 1, !tbaa !119
  %4 = load volatile i32, ptr %1, align 1, !tbaa !119
  %5 = icmp eq i32 %3, %4
  br i1 %5, label %6, label %2, !llvm.loop !122

6:                                                ; preds = %2
  ret i32 %3
}

; Function Attrs: argmemonly mustprogress nocallback nofree nounwind willreturn
declare void @llvm.memcpy.p0.p0.i24(ptr noalias nocapture writeonly, ptr noalias nocapture readonly, i24, i1 immarg) #6

; Function Attrs: minsize optsize
declare dso_local i8 @vdp_getKeyMap(i8 noundef) local_unnamed_addr #2

; Function Attrs: minsize mustprogress nounwind optsize
define linkonce_odr dso_local void @_ZN5rally10DemoDriver5frameERNS_6MotionE(ptr noundef nonnull align 1 dereferenceable(3) %0, ptr noundef nonnull align 1 dereferenceable(31) %1) local_unnamed_addr #4 align 2 {
  %3 = alloca %"struct.rally::Sample", align 1
  %4 = alloca %"struct.rally::Sample", align 1
  %5 = alloca %"struct.rally::Sample", align 1
  %6 = alloca %"struct.rally::Sample", align 1
  %7 = getelementptr inbounds %"struct.rally::Motion", ptr %1, i24 0, i32 2
  %8 = load i32, ptr %7, align 1, !tbaa !53
  %9 = sdiv i32 %8, 100
  %10 = shl nsw i32 %9, 8
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %3) #19
  %11 = load ptr, ptr %1, align 1, !tbaa !113
  call void @_ZN5rally11trackSampleElRKNS_8TrackDefE(ptr nonnull sret(%"struct.rally::Sample") align 1 %3, i32 noundef %10, ptr noundef nonnull align 1 dereferenceable(13) %11) #18
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %4) #19
  %12 = add nsw i32 %10, 16384
  %13 = load ptr, ptr %1, align 1, !tbaa !113
  call void @_ZN5rally11trackSampleElRKNS_8TrackDefE(ptr nonnull sret(%"struct.rally::Sample") align 1 %4, i32 noundef %12, ptr noundef nonnull align 1 dereferenceable(13) %13) #18
  %14 = getelementptr inbounds %"struct.rally::Motion", ptr %1, i24 0, i32 3
  %15 = load i32, ptr %14, align 1, !tbaa !44
  %16 = icmp sgt i32 %15, 10
  br i1 %16, label %17, label %33

17:                                               ; preds = %2
  %18 = getelementptr inbounds %"struct.rally::Sample", ptr %3, i24 0, i32 2
  %19 = load i32, ptr %18, align 1, !tbaa !123
  %20 = getelementptr inbounds %"struct.rally::Sample", ptr %4, i24 0, i32 3
  %21 = load i32, ptr %20, align 1, !tbaa !125
  %22 = mul nsw i32 %21, %19
  %23 = getelementptr inbounds %"struct.rally::Sample", ptr %3, i24 0, i32 3
  %24 = load i32, ptr %23, align 1, !tbaa !125
  %25 = getelementptr inbounds %"struct.rally::Sample", ptr %4, i24 0, i32 2
  %26 = load i32, ptr %25, align 1, !tbaa !123
  %27 = mul nsw i32 %26, %24
  %28 = sub nsw i32 %22, %27
  %29 = sdiv i32 %28, 4096
  %30 = mul nsw i32 %29, 27
  %31 = sdiv i32 %30, 4096
  %32 = trunc i32 %31 to i16
  br label %33

33:                                               ; preds = %2, %17
  %34 = phi i16 [ %32, %17 ], [ 0, %2 ]
  %35 = getelementptr inbounds %"struct.rally::Motion", ptr %1, i24 0, i32 7
  store i16 %34, ptr %35, align 1, !tbaa !54
  %36 = getelementptr inbounds %"struct.rally::Sample", ptr %5, i24 0, i32 2
  %37 = getelementptr inbounds %"struct.rally::Sample", ptr %6, i24 0, i32 3
  %38 = getelementptr inbounds %"struct.rally::Sample", ptr %5, i24 0, i32 3
  %39 = getelementptr inbounds %"struct.rally::Sample", ptr %6, i24 0, i32 2
  br label %40

40:                                               ; preds = %57, %33
  %41 = phi i24 [ 0, %33 ], [ %62, %57 ]
  %42 = phi i32 [ 0, %33 ], [ %78, %57 ]
  %43 = icmp ult i24 %41, 513
  br i1 %43, label %57, label %44

44:                                               ; preds = %40
  %45 = getelementptr inbounds %"struct.rally::Motion", ptr %1, i24 0, i32 8
  %46 = load i24, ptr %45, align 1, !tbaa !2
  %47 = sext i24 %46 to i32
  %48 = mul i32 %47, 46080
  %49 = sdiv i32 %48, 100
  %50 = mul nsw i32 %49, 60
  %51 = getelementptr inbounds %"struct.rally::Motion", ptr %1, i24 0, i32 4
  %52 = load i32, ptr %51, align 1, !tbaa !60
  %53 = call i32 @llvm.abs.i32(i32 %52, i1 true)
  %54 = icmp ugt i32 %53, 24064
  %55 = select i1 %54, i32 200, i32 100
  %56 = sdiv i32 %50, %55
  br label %79

57:                                               ; preds = %40
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %5) #19
  %58 = zext i24 %41 to i32
  %59 = add nsw i32 %9, %58
  %60 = shl nsw i32 %59, 8
  %61 = load ptr, ptr %1, align 1, !tbaa !113
  call void @_ZN5rally11trackSampleElRKNS_8TrackDefE(ptr nonnull sret(%"struct.rally::Sample") align 1 %5, i32 noundef %60, ptr noundef nonnull align 1 dereferenceable(13) %61) #18
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %6) #19
  %62 = add nuw nsw i24 %41, 64
  %63 = zext i24 %62 to i32
  %64 = add nsw i32 %9, %63
  %65 = shl nsw i32 %64, 8
  %66 = load ptr, ptr %1, align 1, !tbaa !113
  call void @_ZN5rally11trackSampleElRKNS_8TrackDefE(ptr nonnull sret(%"struct.rally::Sample") align 1 %6, i32 noundef %65, ptr noundef nonnull align 1 dereferenceable(13) %66) #18
  %67 = load i32, ptr %36, align 1, !tbaa !123
  %68 = load i32, ptr %37, align 1, !tbaa !125
  %69 = mul nsw i32 %68, %67
  %70 = load i32, ptr %38, align 1, !tbaa !125
  %71 = load i32, ptr %39, align 1, !tbaa !123
  %72 = mul nsw i32 %71, %70
  %73 = sub nsw i32 %69, %72
  %74 = sdiv i32 %73, 4096
  %75 = icmp slt i32 %73, -4095
  %76 = sub nsw i32 0, %74
  %77 = select i1 %75, i32 %76, i32 %74
  %78 = call i32 @llvm.smax.i32(i32 %77, i32 %42)
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %6) #19
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %5) #19
  br label %40, !llvm.loop !126

79:                                               ; preds = %88, %44
  %80 = phi i24 [ 224, %44 ], [ %89, %88 ]
  %81 = icmp ugt i24 %80, 40
  br i1 %81, label %82, label %90

82:                                               ; preds = %79
  %83 = zext i24 %80 to i32
  %84 = mul i32 %42, %83
  %85 = mul i32 %84, %83
  %86 = sdiv i32 %85, 1024
  %87 = icmp sgt i32 %86, %56
  br i1 %87, label %88, label %90

88:                                               ; preds = %82
  %89 = add nsw i24 %80, -4
  br label %79, !llvm.loop !127

90:                                               ; preds = %79, %82
  %91 = phi i24 [ 40, %79 ], [ %80, %82 ]
  store i24 %91, ptr %0, align 1, !tbaa !128
  %92 = load i32, ptr %14, align 1, !tbaa !44
  %93 = icmp sgt i32 %92, 10
  br i1 %93, label %94, label %104

94:                                               ; preds = %90
  %95 = mul i32 %52, -2
  %96 = getelementptr inbounds %"struct.rally::Motion", ptr %1, i24 0, i32 5
  %97 = load i32, ptr %96, align 1, !tbaa !63
  %98 = sdiv i32 %97, -2
  %99 = add i32 %98, %95
  %100 = mul nsw i32 %99, 63
  %101 = shl nsw i32 %92, 9
  %102 = sdiv i32 %100, %101
  %103 = trunc i32 %102 to i24
  br label %104

104:                                              ; preds = %90, %94
  %105 = phi i24 [ %103, %94 ], [ 0, %90 ]
  %106 = load i16, ptr %35, align 1, !tbaa !54
  %107 = sext i16 %106 to i24
  %108 = add nsw i24 %105, %107
  %109 = call i24 @llvm.smin.i24(i24 %108, i24 21)
  %110 = call i24 @llvm.smax.i24(i24 %109, i24 -21)
  %111 = getelementptr inbounds %"struct.rally::Motion", ptr %1, i24 0, i32 6
  %112 = load i16, ptr %111, align 1, !tbaa !41
  %113 = sext i16 %112 to i24
  %114 = sub nsw i24 %110, %113
  %115 = call i24 @llvm.smin.i24(i24 %114, i24 3)
  %116 = call i24 @llvm.smax.i24(i24 %115, i24 -3)
  %117 = trunc i24 %116 to i16
  %118 = add i16 %112, %117
  store i16 %118, ptr %111, align 1, !tbaa !41
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %4) #19
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %3) #19
  ret void
}

; Function Attrs: minsize mustprogress nounwind optsize
define linkonce_odr dso_local void @_ZN5rally4game6Engine6updateIPFvPKhjEEEvlT_(ptr noundef nonnull align 1 dereferenceable(4) %0, i32 noundef %1, ptr noundef %2) local_unnamed_addr #4 align 2 {
  %4 = alloca [7 x i8], align 1
  %5 = load i8, ptr %0, align 1, !tbaa !116, !range !34
  %6 = icmp eq i8 %5, 0
  br i1 %6, label %27, label %7

7:                                                ; preds = %3
  %8 = tail call i32 @llvm.smax.i32(i32 %1, i32 0)
  %9 = tail call i32 @llvm.umin.i32(i32 %8, i32 300)
  %10 = trunc i32 %9 to i24
  %11 = shl nuw nsw i24 %10, 1
  %12 = and i24 %11, 1020
  %13 = add nuw nsw i24 %12, 80
  %14 = getelementptr inbounds %"struct.rally::game::Engine", ptr %0, i24 0, i32 1
  %15 = load i24, ptr %14, align 1, !tbaa !118
  %16 = icmp eq i24 %13, %15
  br i1 %16, label %27, label %17

17:                                               ; preds = %7
  call void @llvm.lifetime.start.p0(i64 7, ptr nonnull %4) #19
  store i8 23, ptr %4, align 1, !tbaa !22
  %18 = getelementptr inbounds i8, ptr %4, i24 1
  store i8 0, ptr %18, align 1, !tbaa !22
  %19 = getelementptr inbounds i8, ptr %4, i24 2
  store i8 -123, ptr %19, align 1, !tbaa !22
  %20 = getelementptr inbounds i8, ptr %4, i24 3
  store i8 0, ptr %20, align 1, !tbaa !22
  %21 = getelementptr inbounds i8, ptr %4, i24 4
  store i8 3, ptr %21, align 1, !tbaa !22
  %22 = getelementptr inbounds i8, ptr %4, i24 5
  %23 = trunc i24 %13 to i8
  store i8 %23, ptr %22, align 1, !tbaa !22
  %24 = getelementptr inbounds i8, ptr %4, i24 6
  %25 = lshr i24 %13, 8
  %26 = trunc i24 %25 to i8
  store i8 %26, ptr %24, align 1, !tbaa !22
  call void %2(ptr noundef nonnull %4, i24 noundef 7) #17
  store i24 %13, ptr %14, align 1, !tbaa !118
  call void @llvm.lifetime.end.p0(i64 7, ptr nonnull %4) #19
  br label %27

27:                                               ; preds = %17, %7, %3
  ret void
}

; Function Attrs: minsize mustprogress nounwind optsize
define linkonce_odr dso_local void @_ZN5rally4game16prepareGameSceneINS_10DirectRoadEEEvRNS_6MotionERNS_7TrafficERKNS0_11RaceTrafficERT_RNS_14SceneryHistoryERVNS_3r1810SceneStateEb(ptr noundef nonnull align 1 dereferenceable(31) %0, ptr noundef nonnull align 1 dereferenceable(60) %1, ptr noundef nonnull align 1 dereferenceable(197) %2, ptr noundef nonnull align 1 dereferenceable(2191) %3, ptr noundef nonnull align 1 dereferenceable(11) %4, ptr noundef nonnull align 1 dereferenceable(158) %5, i1 noundef %6) local_unnamed_addr #4 {
  %8 = alloca %"struct.rally::Sample", align 1
  %9 = alloca %"struct.rally::SceneryUpdate", align 1
  %10 = alloca [6 x i24], align 1
  %11 = alloca [6 x i32], align 1
  %12 = alloca %"struct.rally::Sample", align 1
  %13 = alloca %"struct.rally::Sample", align 1
  %14 = alloca %"struct.rally::r18::Pose", align 1
  %15 = getelementptr inbounds %"struct.rally::Motion", ptr %0, i24 0, i32 2
  %16 = load i32, ptr %15, align 1, !tbaa !53
  %17 = getelementptr inbounds %"struct.rally::Motion", ptr %0, i24 0, i32 1
  %18 = load i32, ptr %17, align 1, !tbaa !130
  tail call void @_ZN5rally10DirectRoad7projectElll(ptr noundef nonnull align 1 dereferenceable(2191) %3, i32 noundef %16, i32 noundef %18, i32 noundef 0) #18
  %19 = load i32, ptr %15, align 1, !tbaa !53
  %20 = freeze i32 %19
  %21 = sdiv i32 %20, 100
  %22 = shl nsw i32 %21, 8
  %23 = mul i32 %21, 100
  %24 = sub i32 %20, %23
  %25 = shl nsw i32 %24, 8
  %26 = sdiv i32 %25, 100
  %27 = add nsw i32 %26, %22
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %8) #19
  %28 = load ptr, ptr %0, align 1, !tbaa !113
  call void @_ZN5rally11trackSampleElRKNS_8TrackDefE(ptr nonnull sret(%"struct.rally::Sample") align 1 %8, i32 noundef %27, ptr noundef nonnull align 1 dereferenceable(13) %28) #18
  %29 = getelementptr inbounds %"struct.rally::Sample", ptr %8, i24 0, i32 2
  %30 = load i32, ptr %29, align 1, !tbaa !123
  %31 = getelementptr inbounds %"struct.rally::Sample", ptr %8, i24 0, i32 3
  %32 = load i32, ptr %31, align 1, !tbaa !125
  %33 = call noundef i24 @_ZN5rally14sceneryHeadingEll(i32 noundef %30, i32 noundef %32) #18
  call void @llvm.lifetime.start.p0(i64 10, ptr nonnull %9) #19
  call void @_ZN5rally14SceneryHistory7prepareEi(ptr nonnull sret(%"struct.rally::SceneryUpdate") align 1 %9, ptr noundef nonnull align 1 dereferenceable(11) %4, i24 noundef %33) #18
  store volatile i24 %33, ptr %5, align 1, !tbaa !70
  %34 = load i24, ptr %9, align 1, !tbaa !131
  %35 = getelementptr inbounds %"struct.rally::r18::SceneState", ptr %5, i24 0, i32 1
  store volatile i24 %34, ptr %35, align 1, !tbaa !71
  %36 = getelementptr inbounds %"struct.rally::SceneryUpdate", ptr %9, i24 0, i32 1
  %37 = load i24, ptr %36, align 1, !tbaa !133
  %38 = getelementptr inbounds %"struct.rally::r18::SceneState", ptr %5, i24 0, i32 2
  store volatile i24 %37, ptr %38, align 1, !tbaa !73
  %39 = getelementptr inbounds %"struct.rally::SceneryUpdate", ptr %9, i24 0, i32 2
  %40 = load i24, ptr %39, align 1, !tbaa !134
  %41 = getelementptr inbounds %"struct.rally::r18::SceneState", ptr %5, i24 0, i32 3
  store volatile i24 %40, ptr %41, align 1, !tbaa !74
  %42 = getelementptr inbounds %"struct.rally::SceneryUpdate", ptr %9, i24 0, i32 3
  %43 = load i8, ptr %42, align 1, !tbaa !135, !range !34
  %44 = getelementptr inbounds %"struct.rally::r18::SceneState", ptr %5, i24 0, i32 4
  store volatile i8 %43, ptr %44, align 1, !tbaa !72
  call void @llvm.lifetime.start.p0(i64 18, ptr nonnull %10) #19
  call void @llvm.lifetime.start.p0(i64 24, ptr nonnull %11) #19
  %45 = load ptr, ptr %0, align 1, !tbaa !113
  %46 = getelementptr inbounds %"struct.rally::TrackDef", ptr %45, i24 0, i32 2
  %47 = load i32, ptr %46, align 1, !tbaa !39
  %48 = mul nsw i32 %47, 100
  %49 = load i32, ptr %15, align 1, !tbaa !53
  br label %50

50:                                               ; preds = %53, %7
  %51 = phi i24 [ 0, %7 ], [ %61, %53 ]
  %52 = icmp eq i24 %51, 6
  br i1 %52, label %62, label %53

53:                                               ; preds = %50
  %54 = getelementptr inbounds [6 x i24], ptr %10, i24 0, i24 %51
  store i24 %51, ptr %54, align 1, !tbaa !92
  %55 = getelementptr inbounds [6 x %"struct.rally::Opponent"], ptr %1, i24 0, i24 %51
  %56 = load i32, ptr %55, align 1, !tbaa !136
  %57 = add i32 %56, %48
  %58 = sub i32 %57, %49
  %59 = srem i32 %58, %48
  %60 = getelementptr inbounds [6 x i32], ptr %11, i24 0, i24 %51
  store i32 %59, ptr %60, align 1, !tbaa !46
  %61 = add nuw nsw i24 %51, 1
  br label %50, !llvm.loop !138

62:                                               ; preds = %75, %50
  %63 = phi i24 [ 0, %50 ], [ %73, %75 ]
  %64 = icmp eq i24 %63, 5
  br i1 %64, label %65, label %72

65:                                               ; preds = %62
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %12) #19
  %66 = sdiv i32 %49, 100
  %67 = shl nsw i32 %66, 8
  call void @_ZN5rally11trackSampleElRKNS_8TrackDefE(ptr nonnull sret(%"struct.rally::Sample") align 1 %12, i32 noundef %67, ptr noundef nonnull align 1 dereferenceable(13) %45) #18
  %68 = getelementptr inbounds %"struct.rally::Sample", ptr %12, i24 0, i32 2
  %69 = getelementptr inbounds %"struct.rally::Sample", ptr %13, i24 0, i32 3
  %70 = getelementptr inbounds %"struct.rally::Sample", ptr %12, i24 0, i32 3
  %71 = getelementptr inbounds %"struct.rally::Sample", ptr %13, i24 0, i32 2
  br label %90

72:                                               ; preds = %62
  %73 = add nuw nsw i24 %63, 1
  %74 = getelementptr inbounds [6 x i24], ptr %10, i24 0, i24 %63
  br label %75

75:                                               ; preds = %88, %72
  %76 = phi i24 [ %73, %72 ], [ %89, %88 ]
  %77 = icmp eq i24 %76, 6
  br i1 %77, label %62, label %78, !llvm.loop !139

78:                                               ; preds = %75
  %79 = load i24, ptr %74, align 1, !tbaa !92
  %80 = getelementptr inbounds [6 x i32], ptr %11, i24 0, i24 %79
  %81 = load i32, ptr %80, align 1, !tbaa !46
  %82 = getelementptr inbounds [6 x i24], ptr %10, i24 0, i24 %76
  %83 = load i24, ptr %82, align 1, !tbaa !92
  %84 = getelementptr inbounds [6 x i32], ptr %11, i24 0, i24 %83
  %85 = load i32, ptr %84, align 1, !tbaa !46
  %86 = icmp slt i32 %81, %85
  br i1 %86, label %87, label %88

87:                                               ; preds = %78
  store i24 %83, ptr %74, align 1, !tbaa !92
  store i24 %79, ptr %82, align 1, !tbaa !92
  br label %88

88:                                               ; preds = %78, %87
  %89 = add nuw nsw i24 %76, 1
  br label %75, !llvm.loop !140

90:                                               ; preds = %200, %65
  %91 = phi i24 [ 0, %65 ], [ %202, %200 ]
  %92 = phi i24 [ 0, %65 ], [ %201, %200 ]
  %93 = icmp eq i24 %91, 6
  br i1 %93, label %94, label %120

94:                                               ; preds = %90
  %95 = getelementptr inbounds %"struct.rally::r18::SceneState", ptr %5, i24 0, i32 9
  store volatile i24 %92, ptr %95, align 1, !tbaa !68
  %96 = getelementptr inbounds %"struct.rally::Road", ptr %3, i24 0, i32 5, i24 214
  %97 = load i32, ptr %96, align 1, !tbaa !46
  %98 = sdiv i32 %97, 256
  %99 = trunc i32 %98 to i24
  %100 = getelementptr inbounds %"struct.rally::Motion", ptr %0, i24 0, i32 4
  %101 = load i32, ptr %100, align 1, !tbaa !60
  %102 = mul nsw i32 %101, 118
  %103 = sdiv i32 %102, 12800
  %104 = trunc i32 %103 to i24
  %105 = add nsw i24 %104, %99
  call void @llvm.lifetime.start.p0(i64 2, ptr nonnull %14) #19
  %106 = getelementptr inbounds %"struct.rally::Motion", ptr %0, i24 0, i32 6
  %107 = load i16, ptr %106, align 1, !tbaa !41
  %108 = sext i16 %107 to i24
  call void @_ZN5rally3r1810playerPoseEiib(ptr nonnull sret(%"struct.rally::r18::Pose") align 1 %14, i24 noundef %108, i24 noundef %105, i1 noundef %6) #18
  %109 = getelementptr inbounds %"struct.rally::r18::SceneState", ptr %5, i24 0, i32 7
  store volatile i24 %105, ptr %109, align 1, !tbaa !91
  %110 = load i8, ptr %14, align 1, !tbaa !141
  %111 = zext i8 %110 to i24
  %112 = getelementptr inbounds %"struct.rally::r18::SceneState", ptr %5, i24 0, i32 5
  store volatile i24 %111, ptr %112, align 1, !tbaa !95
  %113 = getelementptr inbounds %"struct.rally::r18::Pose", ptr %14, i24 0, i32 1
  %114 = load i8, ptr %113, align 1, !tbaa !143, !range !34
  %115 = getelementptr inbounds %"struct.rally::r18::SceneState", ptr %5, i24 0, i32 8
  store volatile i8 %114, ptr %115, align 1, !tbaa !96
  %116 = icmp eq i8 %114, 0
  %117 = select i1 %116, i24 -51, i24 -50
  %118 = add i24 %117, %105
  %119 = getelementptr inbounds %"struct.rally::r18::SceneState", ptr %5, i24 0, i32 6
  store volatile i24 %118, ptr %119, align 1, !tbaa !97
  call void @llvm.lifetime.end.p0(i64 2, ptr nonnull %14) #19
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %12) #19
  call void @llvm.lifetime.end.p0(i64 24, ptr nonnull %11) #19
  call void @llvm.lifetime.end.p0(i64 18, ptr nonnull %10) #19
  call void @llvm.lifetime.end.p0(i64 10, ptr nonnull %9) #19
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %8) #19
  ret void

120:                                              ; preds = %90
  %121 = getelementptr inbounds i24, ptr %10, i24 %91
  %122 = load i24, ptr %121, align 1, !tbaa !92
  %123 = getelementptr inbounds [6 x i32], ptr %11, i24 0, i24 %122
  %124 = load i32, ptr %123, align 1, !tbaa !46
  %125 = add i32 %124, -110100
  %126 = icmp ult i32 %125, -103700
  br i1 %126, label %200, label %127

127:                                              ; preds = %120
  %128 = udiv i32 %124, 100
  %129 = trunc i32 %128 to i16
  %130 = udiv i16 8000, %129
  %131 = zext i16 %130 to i24
  %132 = add nuw nsw i24 %131, 96
  %133 = getelementptr inbounds [6 x %"struct.rally::Opponent"], ptr %1, i24 0, i24 %122
  %134 = call noundef i24 @_ZNK5rally10DirectRoad8centerAtEi(ptr noundef nonnull align 1 dereferenceable(2191) %3, i24 noundef %132) #18
  %135 = getelementptr inbounds [6 x %"struct.rally::Opponent"], ptr %1, i24 0, i24 %122, i32 2
  %136 = load i24, ptr %135, align 1, !tbaa !144
  %137 = mul nsw i24 %136, %131
  %138 = sdiv i24 %137, 50
  %139 = add nsw i24 %138, %134
  %140 = shl nuw nsw i24 %131, 1
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %13) #19
  %141 = load i32, ptr %133, align 1, !tbaa !136
  %142 = sdiv i32 %141, 100
  %143 = shl nsw i32 %142, 8
  %144 = load ptr, ptr %0, align 1, !tbaa !113
  call void @_ZN5rally11trackSampleElRKNS_8TrackDefE(ptr nonnull sret(%"struct.rally::Sample") align 1 %13, i32 noundef %143, ptr noundef nonnull align 1 dereferenceable(13) %144) #18
  %145 = load i32, ptr %68, align 1, !tbaa !123
  %146 = load i32, ptr %69, align 1, !tbaa !125
  %147 = mul nsw i32 %146, %145
  %148 = load i32, ptr %70, align 1, !tbaa !125
  %149 = load i32, ptr %71, align 1, !tbaa !123
  %150 = mul nsw i32 %149, %148
  %151 = sub nsw i32 %147, %150
  %152 = sdiv i32 %151, 4096
  %153 = call noundef i16 @_ZN5rally3r1816headingFromCrossEl(i32 noundef %152) #18
  %154 = sext i16 %153 to i24
  %155 = and i24 %122, 1
  %156 = icmp eq i24 %155, 0
  %157 = getelementptr inbounds [6 x %"struct.rally::game::RaceCar"], ptr %2, i24 0, i24 %122, i32 7, i32 2
  %158 = load i16, ptr %157, align 1, !tbaa !145
  %159 = sext i16 %158 to i24
  %160 = sub nsw i24 0, %159
  %161 = select i1 %156, i24 %159, i24 %160
  %162 = add nsw i24 %161, %154
  br i1 %6, label %163, label %167

163:                                              ; preds = %127
  %164 = call noundef i16 @_ZN5rally3r1814viewingBearingEi(i24 noundef %139) #18
  %165 = sext i16 %164 to i24
  %166 = sub nsw i24 %162, %165
  br label %167

167:                                              ; preds = %163, %127
  %168 = phi i24 [ %166, %163 ], [ %162, %127 ]
  %169 = icmp sgt i24 %168, 0
  %170 = zext i1 %169 to i8
  %171 = call i24 @llvm.abs.i24(i24 %168, i1 true)
  %172 = add nuw nsw i24 %171, 672
  %173 = udiv i24 %172, 1344
  %174 = call i24 @llvm.umin.i24(i24 %173, i24 4)
  %175 = add i24 %92, 1
  %176 = getelementptr inbounds %"struct.rally::r18::SceneState", ptr %5, i24 0, i32 10, i24 %92
  %177 = mul i24 %122, 5
  %178 = add i24 %177, 5
  %179 = add nsw i24 %178, %174
  store volatile i24 %179, ptr %176, align 1, !tbaa !88
  %180 = add i24 %122, 63970
  %181 = getelementptr inbounds %"struct.rally::r18::SceneState", ptr %5, i24 0, i32 10, i24 %92, i32 1
  store volatile i24 %180, ptr %181, align 1, !tbaa !85
  %182 = getelementptr inbounds %"struct.rally::r18::SceneState", ptr %5, i24 0, i32 10, i24 %92, i32 2
  store volatile i24 %140, ptr %182, align 1, !tbaa !77
  %183 = sub nsw i24 0, %140
  %184 = select i1 %169, i24 %183, i24 %140
  %185 = getelementptr inbounds %"struct.rally::r18::SceneState", ptr %5, i24 0, i32 10, i24 %92, i32 3
  store volatile i24 %184, ptr %185, align 1, !tbaa !86
  %186 = mul nuw nsw i24 %131, 202
  %187 = select i1 %169, i24 %186, i24 0
  %188 = getelementptr inbounds %"struct.rally::r18::SceneState", ptr %5, i24 0, i32 10, i24 %92, i32 4
  store volatile i24 %187, ptr %188, align 1, !tbaa !87
  %189 = getelementptr inbounds %"struct.rally::r18::SceneState", ptr %5, i24 0, i32 10, i24 %92, i32 7
  store volatile i8 %170, ptr %189, align 1, !tbaa !146
  %190 = mul nuw nsw i16 %130, 102
  %191 = lshr i16 %190, 8
  %192 = zext i16 %191 to i24
  %193 = sub i24 %139, %192
  %194 = getelementptr inbounds %"struct.rally::r18::SceneState", ptr %5, i24 0, i32 10, i24 %92, i32 5
  store volatile i24 %193, ptr %194, align 1, !tbaa !89
  %195 = mul nuw nsw i16 %130, 140
  %196 = lshr i16 %195, 8
  %197 = zext i16 %196 to i24
  %198 = sub nuw nsw i24 %132, %197
  %199 = getelementptr inbounds %"struct.rally::r18::SceneState", ptr %5, i24 0, i32 10, i24 %92, i32 6
  store volatile i24 %198, ptr %199, align 1, !tbaa !90
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %13) #19
  br label %200

200:                                              ; preds = %120, %167
  %201 = phi i24 [ %175, %167 ], [ %92, %120 ]
  %202 = add nuw nsw i24 %91, 1
  br label %90
}

; Function Attrs: minsize mustprogress nounwind optsize
define linkonce_odr dso_local void @_ZN5rally4game10Billboards7prepareINS_10DirectRoadEEEvRKNS_6MotionERKT_(ptr noundef nonnull align 1 dereferenceable(27) %0, ptr noundef nonnull align 1 dereferenceable(31) %1, ptr noundef nonnull align 1 dereferenceable(2191) %2) local_unnamed_addr #4 align 2 {
  %4 = alloca %"struct.rally::game::SignPose", align 1
  %5 = getelementptr inbounds %"struct.rally::game::Billboards", ptr %0, i24 0, i32 1
  store i24 0, ptr %5, align 1, !tbaa !147
  %6 = load ptr, ptr %1, align 1, !tbaa !113
  %7 = getelementptr inbounds %"struct.rally::TrackDef", ptr %6, i24 0, i32 2
  %8 = load i32, ptr %7, align 1, !tbaa !39
  %9 = mul nsw i32 %8, 100
  %10 = sdiv i32 %8, 480
  %11 = trunc i32 %10 to i24
  %12 = getelementptr inbounds %"struct.rally::Motion", ptr %1, i24 0, i32 2
  %13 = load i32, ptr %12, align 1, !tbaa !53
  %14 = mul nsw i32 %13, %10
  %15 = sdiv i32 %14, %9
  %16 = trunc i32 %15 to i24
  %17 = add i24 %16, %11
  br label %18

18:                                               ; preds = %79, %3
  %19 = phi i24 [ -1, %3 ], [ %80, %79 ]
  %20 = icmp eq i24 %19, 3
  br i1 %20, label %21, label %24

21:                                               ; preds = %18
  %22 = load i24, ptr %5, align 1, !tbaa !147
  %23 = icmp eq i24 %22, 2
  br i1 %23, label %81, label %89

24:                                               ; preds = %18
  %25 = add i24 %17, %19
  %26 = srem i24 %25, %11
  %27 = sext i24 %26 to i32
  %28 = mul nsw i32 %9, %27
  %29 = sdiv i32 %28, %10
  %30 = add nsw i32 %29, 24000
  %31 = srem i32 %30, %9
  %32 = icmp slt i32 %31, 0
  %33 = select i1 %32, i32 %9, i32 0
  %34 = load i32, ptr %12, align 1, !tbaa !53
  %35 = add i32 %31, %9
  %36 = sub i32 %35, %34
  %37 = add i32 %36, %33
  %38 = srem i32 %37, %9
  %39 = add i32 %38, -50100
  %40 = icmp ult i32 %39, -43700
  br i1 %40, label %79, label %41

41:                                               ; preds = %24
  %42 = trunc i32 %38 to i16
  %43 = udiv i16 %42, 100
  %44 = udiv i16 8000, %43
  %45 = zext i16 %44 to i24
  %46 = add nuw nsw i24 %45, 96
  %47 = shl nuw nsw i24 %45, 1
  %48 = lshr i16 %44, 1
  %49 = zext i16 %48 to i24
  %50 = sub nuw nsw i24 %46, %49
  %51 = icmp ult i24 %50, 104
  br i1 %51, label %79, label %52

52:                                               ; preds = %41
  %53 = and i24 %26, 1
  %54 = icmp eq i24 %53, 0
  %55 = tail call noundef i24 @_ZNK5rally10DirectRoad8centerAtEi(ptr noundef nonnull align 1 dereferenceable(2191) %2, i24 noundef %46) #18
  %56 = select i1 %54, i16 134, i16 -134
  %57 = mul nsw i16 %44, %56
  %58 = sdiv i16 %57, 50
  %59 = sext i16 %58 to i24
  %60 = lshr i16 %44, 2
  %61 = zext i16 %60 to i24
  %62 = sub nsw i24 %59, %61
  %63 = add i24 %62, %55
  %64 = icmp sgt i24 %63, 319
  %65 = add nsw i24 %63, %49
  %66 = icmp slt i24 %65, 1
  %67 = select i1 %64, i1 true, i1 %66
  br i1 %67, label %79, label %68

68:                                               ; preds = %52
  %69 = load i24, ptr %5, align 1, !tbaa !147
  %70 = icmp ult i24 %69, 2
  br i1 %70, label %71, label %79

71:                                               ; preds = %68
  %72 = srem i24 %26, 8
  %73 = add nsw i24 %72, 120
  %74 = add nuw nsw i24 %69, 1
  store i24 %74, ptr %5, align 1, !tbaa !147
  %75 = getelementptr inbounds [2 x %"struct.rally::game::SignPose"], ptr %0, i24 0, i24 %69
  store i24 %63, ptr %75, align 1, !tbaa.struct !149
  %76 = getelementptr inbounds i8, ptr %75, i24 3
  store i24 %50, ptr %76, align 1, !tbaa.struct !150
  %77 = getelementptr inbounds i8, ptr %75, i24 6
  store i24 %47, ptr %77, align 1, !tbaa.struct !151
  %78 = getelementptr inbounds i8, ptr %75, i24 9
  store i24 %73, ptr %78, align 1, !tbaa.struct !152
  br label %79

79:                                               ; preds = %41, %68, %71, %52, %24
  %80 = add nsw i24 %19, 1
  br label %18, !llvm.loop !153

81:                                               ; preds = %21
  %82 = getelementptr inbounds %"struct.rally::game::SignPose", ptr %0, i24 0, i32 2
  %83 = load i24, ptr %82, align 1, !tbaa !79
  %84 = getelementptr inbounds [2 x %"struct.rally::game::SignPose"], ptr %0, i24 0, i24 1, i32 2
  %85 = load i24, ptr %84, align 1, !tbaa !79
  %86 = icmp sgt i24 %83, %85
  br i1 %86, label %87, label %89

87:                                               ; preds = %81
  %88 = getelementptr inbounds [2 x %"struct.rally::game::SignPose"], ptr %0, i24 0, i24 1
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %4)
  call void @llvm.memcpy.p0.p0.i24(ptr noundef nonnull align 1 dereferenceable(12) %4, ptr noundef nonnull align 1 dereferenceable(12) %0, i24 12, i1 false), !tbaa.struct !149
  tail call void @llvm.memcpy.p0.p0.i24(ptr noundef nonnull align 1 dereferenceable(12) %0, ptr noundef nonnull align 1 dereferenceable(12) %88, i24 12, i1 false), !tbaa.struct !149
  call void @llvm.memcpy.p0.p0.i24(ptr noundef nonnull align 1 dereferenceable(12) %88, ptr noundef nonnull align 1 dereferenceable(12) %4, i24 12, i1 false), !tbaa.struct !149
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %4)
  br label %89

89:                                               ; preds = %87, %81, %21
  ret void
}

; Function Attrs: minsize mustprogress nounwind optsize
define linkonce_odr dso_local void @_ZN5rally10DirectRoad6emitToIPFvPKhjEEEvRNS_6StreamET_b(ptr noundef nonnull align 1 dereferenceable(2191) %0, ptr noundef nonnull align 1 dereferenceable(4100) %1, ptr noundef %2, i1 noundef %3) local_unnamed_addr #4 align 2 {
  %5 = getelementptr inbounds %"struct.rally::Stream", ptr %1, i24 0, i32 1
  store i24 0, ptr %5, align 1, !tbaa !24
  %6 = getelementptr inbounds %"struct.rally::Stream", ptr %1, i24 0, i32 2
  store i8 0, ptr %6, align 1, !tbaa !26
  %7 = getelementptr inbounds %"struct.rally::Road", ptr %0, i24 0, i32 7
  store i24 0, ptr %7, align 1, !tbaa !154
  br i1 %3, label %8, label %9

8:                                                ; preds = %4
  tail call void @_ZN5rally6Stream4rectEiiiii(ptr noundef nonnull align 1 dereferenceable(4100) %1, i24 noundef 0, i24 noundef 0, i24 noundef 319, i24 noundef 103, i24 noundef 4) #18
  br label %9

9:                                                ; preds = %8, %4
  tail call void @_ZN5rally6Stream4rectEiiiii(ptr noundef nonnull align 1 dereferenceable(4100) %1, i24 noundef 0, i24 noundef 104, i24 noundef 319, i24 noundef 223, i24 noundef 2) #18
  br label %10

10:                                               ; preds = %37, %9
  %11 = phi i24 [ 104, %9 ], [ %23, %37 ]
  %12 = icmp slt i24 %11, 224
  %13 = load i24, ptr %5, align 1, !tbaa !24
  br i1 %12, label %17, label %14

14:                                               ; preds = %10
  %15 = add i24 %13, -4082
  %16 = icmp ult i24 %15, -4097
  br i1 %16, label %40, label %41

17:                                               ; preds = %10
  %18 = add i24 %13, -3942
  %19 = icmp ult i24 %18, -4097
  br i1 %19, label %20, label %21

20:                                               ; preds = %17
  tail call void %2(ptr noundef nonnull %1, i24 noundef %13) #17
  store i24 0, ptr %5, align 1, !tbaa !24
  br label %21

21:                                               ; preds = %20, %17
  %22 = tail call noundef i24 @_ZNK5rally4Road7bandEndEi(ptr noundef nonnull align 1 dereferenceable(2167) %0, i24 noundef %11) #18
  %23 = add nsw i24 %22, 1
  %24 = getelementptr inbounds %"struct.rally::Road", ptr %0, i24 0, i32 6, i24 %11
  %25 = load i8, ptr %24, align 1, !tbaa !12, !range !34
  %26 = icmp eq i8 %25, 0
  %27 = select i1 %26, i24 15, i24 9
  tail call void @_ZNK5rally4Road5stripERNS_6StreamEiiiii(ptr noundef nonnull align 1 dereferenceable(2167) %0, ptr noundef nonnull align 1 dereferenceable(4100) %1, i24 noundef %11, i24 noundef %23, i24 noundef -106, i24 noundef 106, i24 noundef %27) #18
  tail call void @_ZNK5rally4Road5stripERNS_6StreamEiiiii(ptr noundef nonnull align 1 dereferenceable(2167) %0, ptr noundef nonnull align 1 dereferenceable(4100) %1, i24 noundef %11, i24 noundef %23, i24 noundef -90, i24 noundef 90, i24 noundef 8) #18
  %28 = load i8, ptr %24, align 1, !tbaa !12, !range !34
  %29 = icmp eq i8 %28, 0
  %30 = select i1 %29, i24 15, i24 11
  tail call void @_ZNK5rally4Road5stripERNS_6StreamEiiiii(ptr noundef nonnull align 1 dereferenceable(2167) %0, ptr noundef nonnull align 1 dereferenceable(4100) %1, i24 noundef %11, i24 noundef %23, i24 noundef -86, i24 noundef -84, i24 noundef %30) #18
  %31 = load i8, ptr %24, align 1, !tbaa !12, !range !34
  %32 = icmp eq i8 %31, 0
  %33 = select i1 %32, i24 15, i24 11
  tail call void @_ZNK5rally4Road5stripERNS_6StreamEiiiii(ptr noundef nonnull align 1 dereferenceable(2167) %0, ptr noundef nonnull align 1 dereferenceable(4100) %1, i24 noundef %11, i24 noundef %23, i24 noundef 84, i24 noundef 86, i24 noundef %33) #18
  %34 = load i8, ptr %24, align 1, !tbaa !12, !range !34
  %35 = icmp eq i8 %34, 0
  br i1 %35, label %37, label %36

36:                                               ; preds = %21
  tail call void @_ZNK5rally4Road5stripERNS_6StreamEiiiii(ptr noundef nonnull align 1 dereferenceable(2167) %0, ptr noundef nonnull align 1 dereferenceable(4100) %1, i24 noundef %11, i24 noundef %23, i24 noundef -2, i24 noundef 2, i24 noundef 11) #18
  br label %37

37:                                               ; preds = %36, %21
  %38 = load i24, ptr %7, align 1, !tbaa !154
  %39 = add i24 %38, 1
  store i24 %39, ptr %7, align 1, !tbaa !154
  br label %10, !llvm.loop !155

40:                                               ; preds = %14
  tail call void %2(ptr noundef nonnull %1, i24 noundef %13) #17
  store i24 0, ptr %5, align 1, !tbaa !24
  br label %41

41:                                               ; preds = %40, %14
  tail call void @_ZN5rally6Stream4rectEiiiii(ptr noundef nonnull align 1 dereferenceable(4100) %1, i24 noundef 0, i24 noundef 224, i24 noundef 319, i24 noundef 239, i24 noundef 0) #18
  %42 = load i24, ptr %5, align 1, !tbaa !24
  %43 = icmp eq i24 %42, 0
  br i1 %43, label %45, label %44

44:                                               ; preds = %41
  tail call void %2(ptr noundef nonnull %1, i24 noundef %42) #17
  br label %45

45:                                               ; preds = %44, %41
  store i24 0, ptr %5, align 1, !tbaa !24
  ret void
}

; Function Attrs: inlinehint minsize mustprogress nounwind optsize
define linkonce_odr dso_local void @_ZN5rally4game8viewportERNS_6StreamEiiii(ptr noundef nonnull align 1 dereferenceable(4100) %0, i24 noundef %1, i24 noundef %2, i24 noundef %3, i24 noundef %4) local_unnamed_addr #3 {
  %6 = getelementptr inbounds %"struct.rally::Stream", ptr %0, i24 0, i32 1
  %7 = load i24, ptr %6, align 1, !tbaa !24
  %8 = icmp ult i24 %7, 4096
  br i1 %8, label %9, label %12

9:                                                ; preds = %5
  %10 = add nuw nsw i24 %7, 1
  store i24 %10, ptr %6, align 1, !tbaa !24
  %11 = getelementptr inbounds [4096 x i8], ptr %0, i24 0, i24 %7
  store i8 24, ptr %11, align 1, !tbaa !22
  br label %14

12:                                               ; preds = %5
  %13 = getelementptr inbounds %"struct.rally::Stream", ptr %0, i24 0, i32 2
  store i8 1, ptr %13, align 1, !tbaa !26
  br label %14

14:                                               ; preds = %9, %12
  tail call void @_ZN5rally6Stream4wordEi(ptr noundef nonnull align 1 dereferenceable(4100) %0, i24 noundef %1) #18
  tail call void @_ZN5rally6Stream4wordEi(ptr noundef nonnull align 1 dereferenceable(4100) %0, i24 noundef %4) #18
  tail call void @_ZN5rally6Stream4wordEi(ptr noundef nonnull align 1 dereferenceable(4100) %0, i24 noundef %3) #18
  tail call void @_ZN5rally6Stream4wordEi(ptr noundef nonnull align 1 dereferenceable(4100) %0, i24 noundef %2) #18
  tail call void @_ZN5rally6Stream4plotEiii(ptr noundef nonnull align 1 dereferenceable(4100) %0, i24 noundef 4, i24 noundef %1, i24 noundef %2) #18
  ret void
}

; Function Attrs: minsize mustprogress nounwind optsize
define internal fastcc void @_ZN12_GLOBAL__N_15flushEv() unnamed_addr #4 {
  %1 = load i24, ptr getelementptr inbounds (%"struct.rally::Stream", ptr @_ZN12_GLOBAL__N_16streamE, i24 0, i32 1), align 1, !tbaa !24
  tail call void @_ZN12_GLOBAL__N_14sendEPKhj(ptr noundef nonnull @_ZN12_GLOBAL__N_16streamE, i24 noundef %1) #18
  store i24 0, ptr getelementptr inbounds (%"struct.rally::Stream", ptr @_ZN12_GLOBAL__N_16streamE, i24 0, i32 1), align 1, !tbaa !24
  store i8 0, ptr getelementptr inbounds (%"struct.rally::Stream", ptr @_ZN12_GLOBAL__N_16streamE, i24 0, i32 2), align 1, !tbaa !26
  ret void
}

; Function Attrs: minsize optsize
declare dso_local void @vdp_swap() local_unnamed_addr #2

; Function Attrs: inlinehint minsize nounwind optsize
define linkonce_odr dso_local noundef i1 @_ZN5rally4game11saveRecordsERKNS0_7RecordsE(ptr noundef nonnull align 1 dereferenceable(2304) %0) local_unnamed_addr #7 {
  %2 = alloca %"struct.rally::game::Records", align 1
  %3 = tail call noundef i1 @_ZN5rally4game12writeRecordsEPKcRKNS0_7RecordsE(ptr noundef nonnull @.str.58, ptr noundef nonnull align 1 dereferenceable(2304) %0) #18
  br i1 %3, label %4, label %20

4:                                                ; preds = %1
  call void @llvm.lifetime.start.p0(i64 2304, ptr nonnull %2) #19
  call void @llvm.memset.p0.i24(ptr noundef nonnull align 1 dereferenceable(2304) %2, i8 0, i24 2304, i1 false), !tbaa !46
  %5 = call noundef i1 @_ZN5rally4game11readRecordsEPKcRNS0_7RecordsE(ptr noundef nonnull @.str.11, ptr noundef nonnull align 1 dereferenceable(2304) %2) #18
  br i1 %5, label %6, label %8

6:                                                ; preds = %4
  %7 = call noundef i1 @_ZN5rally4game12writeRecordsEPKcRKNS0_7RecordsE(ptr noundef nonnull @.str.12, ptr noundef nonnull align 1 dereferenceable(2304) %2) #18
  br i1 %7, label %8, label %18

8:                                                ; preds = %6, %4
  %9 = call ptr @fopen(ptr noundef nonnull @.str.11, ptr noundef nonnull @.str.15) #18
  %10 = icmp eq ptr %9, null
  br i1 %10, label %15, label %11

11:                                               ; preds = %8
  %12 = call i24 @fclose(ptr noundef nonnull %9) #18
  %13 = call i24 @remove(ptr noundef nonnull @.str.11) #18
  %14 = icmp eq i24 %13, 0
  br i1 %14, label %15, label %18

15:                                               ; preds = %11, %8
  %16 = call i8 @mos_ren(ptr noundef nonnull @.str.58, ptr noundef nonnull @.str.11) #17
  %17 = icmp eq i8 %16, 0
  br label %18

18:                                               ; preds = %15, %11, %6
  %19 = phi i1 [ false, %6 ], [ %17, %15 ], [ false, %11 ]
  call void @llvm.lifetime.end.p0(i64 2304, ptr nonnull %2) #19
  br label %20

20:                                               ; preds = %1, %18
  %21 = phi i1 [ %19, %18 ], [ false, %1 ]
  ret i1 %21
}

; Function Attrs: minsize mustprogress nounwind optsize
define linkonce_odr dso_local void @_ZN5rally4game6Engine4stopIPFvPKhjEEEvT_(ptr noundef nonnull align 1 dereferenceable(4) %0, ptr noundef %1) local_unnamed_addr #4 align 2 {
  %3 = alloca [6 x i8], align 1
  %4 = load i8, ptr %0, align 1, !tbaa !116, !range !34
  %5 = icmp eq i8 %4, 0
  br i1 %5, label %7, label %6

6:                                                ; preds = %2
  call void @llvm.lifetime.start.p0(i64 6, ptr nonnull %3) #19
  call void @llvm.memcpy.p0.p0.i24(ptr noundef nonnull align 1 dereferenceable(6) %3, ptr noundef nonnull align 1 dereferenceable(6) @__const._ZN5rally4game6Engine4stopIPFvPKhjEEEvT_.mute, i24 6, i1 false)
  call void %1(ptr noundef nonnull %3, i24 noundef 6) #17
  store i8 0, ptr %0, align 1, !tbaa !116
  call void @llvm.lifetime.end.p0(i64 6, ptr nonnull %3) #19
  br label %7

7:                                                ; preds = %2, %6
  ret void
}

; Function Attrs: minsize mustprogress nounwind optsize
define internal fastcc void @_ZN12_GLOBAL__N_14fontEj(i24 noundef %0) unnamed_addr #4 {
  %2 = alloca [7 x i8], align 1
  call void @llvm.lifetime.start.p0(i64 7, ptr nonnull %2) #19
  store i8 23, ptr %2, align 1, !tbaa !22
  %3 = getelementptr inbounds i8, ptr %2, i24 1
  store i8 0, ptr %3, align 1, !tbaa !22
  %4 = getelementptr inbounds i8, ptr %2, i24 2
  store i8 -107, ptr %4, align 1, !tbaa !22
  %5 = getelementptr inbounds i8, ptr %2, i24 3
  store i8 0, ptr %5, align 1, !tbaa !22
  %6 = getelementptr inbounds i8, ptr %2, i24 4
  %7 = trunc i24 %0 to i8
  store i8 %7, ptr %6, align 1, !tbaa !22
  %8 = getelementptr inbounds i8, ptr %2, i24 5
  %9 = lshr i24 %0, 8
  %10 = trunc i24 %9 to i8
  store i8 %10, ptr %8, align 1, !tbaa !22
  %11 = getelementptr inbounds i8, ptr %2, i24 6
  store i8 0, ptr %11, align 1, !tbaa !22
  call void @_ZN12_GLOBAL__N_14sendEPKhj(ptr noundef nonnull %2, i24 noundef 7) #18
  call void @llvm.lifetime.end.p0(i64 7, ptr nonnull %2) #19
  ret void
}

; Function Attrs: minsize optsize
declare dso_local void @vdp_adv_clear_buffer(i24 noundef) local_unnamed_addr #2

; Function Attrs: minsize optsize
declare dso_local void @vdp_set_logical_coordinates() local_unnamed_addr #2

; Function Attrs: minsize mustprogress norecurse nounwind optsize
define dso_local noundef i24 @main(i24 noundef %0, ptr nocapture noundef readonly %1) local_unnamed_addr #8 {
  %3 = tail call noundef i24 @_Z8gameMainiPPc(i24 noundef %0, ptr noundef %1) #18, !range !156
  tail call void @_ZN5rally4game6Engine4stopIPFvPKhjEEEvT_(ptr noundef nonnull align 1 dereferenceable(4) @_ZN12_GLOBAL__N_16engineE, ptr noundef nonnull @_ZN12_GLOBAL__N_14sendEPKhj) #18
  ret i24 %3
}

; Function Attrs: minsize nofree nounwind optsize
declare dso_local noalias noundef ptr @fopen(ptr nocapture noundef readonly, ptr nocapture noundef readonly) local_unnamed_addr #9

; Function Attrs: minsize nofree nounwind optsize
declare dso_local noundef i24 @fread(ptr nocapture noundef, i24 noundef, i24 noundef, ptr nocapture noundef) local_unnamed_addr #9

; Function Attrs: minsize nofree nounwind optsize
declare dso_local noundef i24 @fgetc(ptr nocapture noundef) local_unnamed_addr #9

; Function Attrs: minsize nofree nounwind optsize
declare dso_local noundef i24 @fclose(ptr nocapture noundef) local_unnamed_addr #9

; Function Attrs: minsize mustprogress nounwind optsize
define linkonce_odr dso_local noundef i1 @_ZN5rally4game7Records6decodeEPKhj(ptr noundef nonnull align 1 dereferenceable(2304) %0, ptr noundef %1, i24 noundef %2) local_unnamed_addr #4 align 2 {
  %4 = icmp eq i24 %2, 2320
  br i1 %4, label %5, label %45

5:                                                ; preds = %3
  %6 = tail call i24 @memcmp(ptr noundef %1, ptr noundef nonnull @.str.16, i24 noundef 8) #17
  %7 = icmp eq i24 %6, 0
  br i1 %7, label %8, label %45

8:                                                ; preds = %5
  %9 = getelementptr inbounds i8, ptr %1, i24 8
  %10 = tail call noundef i32 @_ZN5rally4game7Records5get32EPKh(ptr noundef nonnull %9) #18
  %11 = icmp eq i32 %10, 288
  br i1 %11, label %12, label %45

12:                                               ; preds = %8
  %13 = getelementptr inbounds i8, ptr %1, i24 12
  %14 = tail call noundef i32 @_ZN5rally4game7Records5get32EPKh(ptr noundef nonnull %13) #18
  %15 = getelementptr inbounds i8, ptr %1, i24 16
  %16 = tail call noundef i32 @_ZN5rally4game7Records4hashEPKhj(ptr noundef nonnull %15, i24 noundef 2304) #18
  %17 = icmp eq i32 %14, %16
  br i1 %17, label %18, label %45

18:                                               ; preds = %12
  %19 = getelementptr inbounds i8, ptr %1, i24 20
  br label %20

20:                                               ; preds = %28, %18
  %21 = phi i24 [ %32, %28 ], [ 0, %18 ]
  %22 = icmp eq i24 %21, 288
  br i1 %22, label %33, label %23

23:                                               ; preds = %20
  %24 = shl nuw nsw i24 %21, 3
  %25 = getelementptr inbounds i8, ptr %15, i24 %24
  %26 = tail call noundef i32 @_ZN5rally4game7Records5get32EPKh(ptr noundef nonnull %25) #18
  %27 = icmp ugt i32 %26, 9999999
  br i1 %27, label %45, label %28

28:                                               ; preds = %23
  %29 = getelementptr inbounds i8, ptr %19, i24 %24
  %30 = tail call noundef i32 @_ZN5rally4game7Records5get32EPKh(ptr noundef nonnull %29) #18
  %31 = icmp ugt i32 %30, 216000
  %32 = add nuw nsw i24 %21, 1
  br i1 %31, label %45, label %20, !llvm.loop !157

33:                                               ; preds = %20, %36
  %34 = phi i24 [ %44, %36 ], [ 0, %20 ]
  %35 = icmp eq i24 %34, 288
  br i1 %35, label %45, label %36

36:                                               ; preds = %33
  %37 = shl nuw nsw i24 %34, 3
  %38 = getelementptr inbounds i8, ptr %15, i24 %37
  %39 = tail call noundef i32 @_ZN5rally4game7Records5get32EPKh(ptr noundef nonnull %38) #18
  %40 = getelementptr inbounds i8, ptr %19, i24 %37
  %41 = tail call noundef i32 @_ZN5rally4game7Records5get32EPKh(ptr noundef nonnull %40) #18
  %42 = getelementptr inbounds [288 x %"struct.rally::game::Record"], ptr %0, i24 0, i24 %34
  store i32 %39, ptr %42, align 1, !tbaa.struct !158
  %43 = getelementptr inbounds i8, ptr %42, i24 4
  store i32 %41, ptr %43, align 1, !tbaa.struct !159
  %44 = add nuw nsw i24 %34, 1
  br label %33, !llvm.loop !160

45:                                               ; preds = %23, %28, %33, %3, %5, %8, %12
  %46 = phi i1 [ false, %12 ], [ false, %8 ], [ false, %5 ], [ false, %3 ], [ true, %33 ], [ false, %28 ], [ false, %23 ]
  ret i1 %46
}

; Function Attrs: minsize optsize
declare dso_local i24 @memcmp(ptr noundef, ptr noundef, i24 noundef) local_unnamed_addr #2

; Function Attrs: minsize mustprogress nounwind optsize
define linkonce_odr dso_local noundef i32 @_ZN5rally4game7Records5get32EPKh(ptr noundef %0) local_unnamed_addr #4 align 2 {
  br label %2

2:                                                ; preds = %7, %1
  %3 = phi i32 [ 0, %1 ], [ %14, %7 ]
  %4 = phi i24 [ 0, %1 ], [ %15, %7 ]
  %5 = icmp eq i24 %4, 4
  br i1 %5, label %6, label %7

6:                                                ; preds = %2
  ret i32 %3

7:                                                ; preds = %2
  %8 = getelementptr inbounds i8, ptr %0, i24 %4
  %9 = load i8, ptr %8, align 1, !tbaa !22
  %10 = zext i8 %9 to i32
  %11 = shl nuw nsw i24 %4, 3
  %12 = zext i24 %11 to i32
  %13 = shl nuw i32 %10, %12
  %14 = or i32 %13, %3
  %15 = add nuw nsw i24 %4, 1
  br label %2, !llvm.loop !161
}

; Function Attrs: minsize mustprogress nounwind optsize
define linkonce_odr dso_local noundef i32 @_ZN5rally4game7Records4hashEPKhj(ptr noundef %0, i24 noundef %1) local_unnamed_addr #4 align 2 {
  br label %3

3:                                                ; preds = %8, %2
  %4 = phi i32 [ -2128831035, %2 ], [ %13, %8 ]
  %5 = phi i24 [ 0, %2 ], [ %14, %8 ]
  %6 = icmp eq i24 %5, %1
  br i1 %6, label %7, label %8

7:                                                ; preds = %3
  ret i32 %4

8:                                                ; preds = %3
  %9 = getelementptr inbounds i8, ptr %0, i24 %5
  %10 = load i8, ptr %9, align 1, !tbaa !22
  %11 = zext i8 %10 to i32
  %12 = xor i32 %4, %11
  %13 = mul i32 %12, 16777619
  %14 = add i24 %5, 1
  br label %3, !llvm.loop !162
}

; Function Attrs: minsize mustprogress nounwind optsize
define linkonce_odr dso_local void @_ZN5rally4Road4initEv(ptr noundef nonnull align 1 dereferenceable(2167) %0) local_unnamed_addr #4 align 2 {
  %2 = getelementptr inbounds %"struct.rally::Road", ptr %0, i24 0, i32 4
  store i32 0, ptr %2, align 1, !tbaa !46
  %3 = getelementptr inbounds %"struct.rally::Road", ptr %0, i24 0, i32 3
  store i32 0, ptr %3, align 1, !tbaa !46
  br label %4

4:                                                ; preds = %8, %1
  %5 = phi i24 [ 1, %1 ], [ %14, %8 ]
  %6 = icmp eq i24 %5, 129
  br i1 %6, label %7, label %8

7:                                                ; preds = %4
  ret void

8:                                                ; preds = %4
  %9 = zext i24 %5 to i32
  %10 = udiv i32 800000, %9
  %11 = getelementptr inbounds %"struct.rally::Road", ptr %0, i24 0, i32 3, i24 %5
  store i32 %10, ptr %11, align 1, !tbaa !46
  %12 = udiv i32 2048000, %9
  %13 = getelementptr inbounds %"struct.rally::Road", ptr %0, i24 0, i32 4, i24 %5
  store i32 %12, ptr %13, align 1, !tbaa !46
  %14 = add nuw nsw i24 %5, 1
  br label %4, !llvm.loop !163
}

; Function Attrs: minsize optsize
declare dso_local void @vdp_adv_write_block_data(i24 noundef, i24 noundef, ptr noundef) local_unnamed_addr #2

; Function Attrs: minsize optsize
declare dso_local void @vdp_select_bitmap(i24 noundef) local_unnamed_addr #2

; Function Attrs: minsize optsize
declare dso_local void @vdp_adv_bitmap_from_buffer(i24 noundef, i24 noundef, i24 noundef) local_unnamed_addr #2

; Function Attrs: inlinehint minsize mustprogress nounwind optsize
define linkonce_odr dso_local noundef i8 @_ZN5rally9carColourEhj(i8 noundef %0, i24 noundef %1) local_unnamed_addr #3 {
  %3 = add i24 %1, -7
  %4 = icmp ult i24 %3, -6
  br i1 %4, label %22, label %5

5:                                                ; preds = %2
  %6 = add nsw i24 %1, -1
  switch i8 %0, label %22 [
    i8 -62, label %7
    i8 -61, label %9
    i8 -57, label %11
    i8 -49, label %13
    i8 -17, label %15
    i8 -8, label %17
  ]

7:                                                ; preds = %5
  %8 = getelementptr inbounds [6 x [6 x i8]], ptr @_ZZN5rally9carColourEhjE7colours, i24 0, i24 %6
  br label %19

9:                                                ; preds = %5
  %10 = getelementptr inbounds [6 x [6 x i8]], ptr @_ZZN5rally9carColourEhjE7colours, i24 0, i24 %6, i24 1
  br label %19

11:                                               ; preds = %5
  %12 = getelementptr inbounds [6 x [6 x i8]], ptr @_ZZN5rally9carColourEhjE7colours, i24 0, i24 %6, i24 2
  br label %19

13:                                               ; preds = %5
  %14 = getelementptr inbounds [6 x [6 x i8]], ptr @_ZZN5rally9carColourEhjE7colours, i24 0, i24 %6, i24 3
  br label %19

15:                                               ; preds = %5
  %16 = getelementptr inbounds [6 x [6 x i8]], ptr @_ZZN5rally9carColourEhjE7colours, i24 0, i24 %6, i24 4
  br label %19

17:                                               ; preds = %5
  %18 = getelementptr inbounds [6 x [6 x i8]], ptr @_ZZN5rally9carColourEhjE7colours, i24 0, i24 %6, i24 5
  br label %19

19:                                               ; preds = %17, %15, %13, %11, %9, %7
  %20 = phi ptr [ %8, %7 ], [ %10, %9 ], [ %12, %11 ], [ %14, %13 ], [ %16, %15 ], [ %18, %17 ]
  %21 = load i8, ptr %20, align 1, !tbaa !22
  br label %22

22:                                               ; preds = %19, %5, %2
  %23 = phi i8 [ %0, %2 ], [ %0, %5 ], [ %21, %19 ]
  ret i8 %23
}

; Function Attrs: minsize mustprogress nounwind optsize
define linkonce_odr dso_local void @_ZN5rally6Stream4wordEi(ptr noundef nonnull align 1 dereferenceable(4100) %0, i24 noundef %1) local_unnamed_addr #4 align 2 {
  %3 = getelementptr inbounds %"struct.rally::Stream", ptr %0, i24 0, i32 1
  %4 = load i24, ptr %3, align 1, !tbaa !24
  %5 = icmp ult i24 %4, 4096
  br i1 %5, label %6, label %17

6:                                                ; preds = %2
  %7 = trunc i24 %1 to i8
  %8 = add nuw nsw i24 %4, 1
  store i24 %8, ptr %3, align 1, !tbaa !24
  %9 = getelementptr inbounds [4096 x i8], ptr %0, i24 0, i24 %4
  store i8 %7, ptr %9, align 1, !tbaa !22
  %10 = load i24, ptr %3, align 1, !tbaa !24
  %11 = icmp ult i24 %10, 4096
  br i1 %11, label %12, label %17

12:                                               ; preds = %6
  %13 = lshr i24 %1, 8
  %14 = trunc i24 %13 to i8
  %15 = add nuw nsw i24 %10, 1
  store i24 %15, ptr %3, align 1, !tbaa !24
  %16 = getelementptr inbounds [4096 x i8], ptr %0, i24 0, i24 %10
  store i8 %14, ptr %16, align 1, !tbaa !22
  br label %19

17:                                               ; preds = %2, %6
  %18 = getelementptr inbounds %"struct.rally::Stream", ptr %0, i24 0, i32 2
  store i8 1, ptr %18, align 1, !tbaa !26
  br label %19

19:                                               ; preds = %12, %17
  ret void
}

; Function Attrs: minsize optsize
declare dso_local void @mos_puts(ptr noundef, i24 noundef, i8 noundef) local_unnamed_addr #2

; Function Attrs: minsize optsize
declare dso_local void @vdp_set_text_colour(i24 noundef) local_unnamed_addr #2

; Function Attrs: minsize optsize
declare dso_local void @vdp_set_text_bg_colour(i24 noundef) local_unnamed_addr #2

; Function Attrs: minsize mustprogress nounwind optsize
define internal fastcc void @_ZN12_GLOBAL__N_110fontCreateEjj(i24 noundef %0, i24 noundef %1) unnamed_addr #4 {
  %3 = alloca [10 x i8], align 1
  call void @llvm.lifetime.start.p0(i64 10, ptr nonnull %3) #19
  store i8 23, ptr %3, align 1, !tbaa !22
  %4 = getelementptr inbounds i8, ptr %3, i24 1
  store i8 0, ptr %4, align 1, !tbaa !22
  %5 = getelementptr inbounds i8, ptr %3, i24 2
  store i8 -107, ptr %5, align 1, !tbaa !22
  %6 = getelementptr inbounds i8, ptr %3, i24 3
  store i8 1, ptr %6, align 1, !tbaa !22
  %7 = getelementptr inbounds i8, ptr %3, i24 4
  %8 = trunc i24 %0 to i8
  store i8 %8, ptr %7, align 1, !tbaa !22
  %9 = getelementptr inbounds i8, ptr %3, i24 5
  store i8 -7, ptr %9, align 1, !tbaa !22
  %10 = getelementptr inbounds i8, ptr %3, i24 6
  %11 = trunc i24 %1 to i8
  store i8 %11, ptr %10, align 1, !tbaa !22
  %12 = getelementptr inbounds i8, ptr %3, i24 7
  store i8 %11, ptr %12, align 1, !tbaa !22
  %13 = getelementptr inbounds i8, ptr %3, i24 8
  %14 = add i8 %11, -1
  store i8 %14, ptr %13, align 1, !tbaa !22
  %15 = getelementptr inbounds i8, ptr %3, i24 9
  store i8 0, ptr %15, align 1, !tbaa !22
  call void @_ZN12_GLOBAL__N_14sendEPKhj(ptr noundef nonnull %3, i24 noundef 10) #18
  call void @llvm.lifetime.end.p0(i64 10, ptr nonnull %3) #19
  ret void
}

; Function Attrs: minsize mustprogress nounwind optsize
define linkonce_odr dso_local void @_ZN5rally4game11RaceTraffic5resetENS0_6PolicyElhh(ptr noundef nonnull align 1 dereferenceable(197) %0, i8 noundef %1, i32 noundef %2, i8 noundef %3, i8 noundef %4) local_unnamed_addr #4 align 2 {
  %6 = getelementptr inbounds %"struct.rally::game::RaceTraffic", ptr %0, i24 0, i32 2
  store i8 %1, ptr %6, align 1, !tbaa !164
  %7 = getelementptr inbounds %"struct.rally::game::RaceTraffic", ptr %0, i24 0, i32 3
  store i32 %2, ptr %7, align 1, !tbaa !166
  %8 = zext i8 %4 to i32
  %9 = mul i32 %8, %2
  %10 = getelementptr inbounds %"struct.rally::game::RaceTraffic", ptr %0, i24 0, i32 4
  store i32 %9, ptr %10, align 1, !tbaa !167
  %11 = getelementptr inbounds %"struct.rally::game::RaceTraffic", ptr %0, i24 0, i32 5
  store i32 0, ptr %11, align 1, !tbaa !168
  %12 = getelementptr inbounds %"struct.rally::game::RaceTraffic", ptr %0, i24 0, i32 6
  store i8 %3, ptr %12, align 1, !tbaa !169
  %13 = getelementptr inbounds %"struct.rally::game::RaceTraffic", ptr %0, i24 0, i32 1
  store i8 0, ptr %13, align 1, !tbaa.struct !170
  %14 = getelementptr inbounds %"struct.rally::game::RaceTraffic", ptr %0, i24 0, i32 1, i32 1
  store i16 60, ptr %14, align 1, !tbaa.struct !171
  %15 = getelementptr inbounds %"struct.rally::game::RaceTraffic", ptr %0, i24 0, i32 1, i32 2
  store i16 0, ptr %15, align 1, !tbaa.struct !172
  %16 = getelementptr inbounds %"struct.rally::game::RaceTraffic", ptr %0, i24 0, i32 1, i32 3
  store i32 0, ptr %16, align 1, !tbaa.struct !159
  %17 = icmp eq i8 %1, 0
  %18 = zext i8 %3 to i24
  br label %19

19:                                               ; preds = %30, %5
  %20 = phi i24 [ 0, %5 ], [ %31, %30 ]
  %21 = icmp eq i24 %20, 6
  br i1 %21, label %22, label %23

22:                                               ; preds = %19
  ret void

23:                                               ; preds = %19
  %24 = getelementptr inbounds [6 x %"struct.rally::game::RaceCar"], ptr %0, i24 0, i24 %20
  %25 = getelementptr inbounds i8, ptr %24, i24 21
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 1 dereferenceable(21) %24, i8 0, i64 21, i1 false)
  store i16 60, ptr %25, align 1, !tbaa.struct !171
  %26 = getelementptr inbounds i8, ptr %24, i24 23
  store i16 0, ptr %26, align 1, !tbaa.struct !172
  %27 = getelementptr inbounds i8, ptr %24, i24 25
  store i32 0, ptr %27, align 1, !tbaa.struct !159
  br i1 %17, label %32, label %28

28:                                               ; preds = %23
  %29 = add nuw nsw i24 %20, 1
  br label %30

30:                                               ; preds = %28, %32
  %31 = phi i24 [ %29, %28 ], [ %34, %32 ]
  br label %19, !llvm.loop !173

32:                                               ; preds = %23
  store i8 1, ptr %24, align 1, !tbaa !55
  %33 = getelementptr inbounds [6 x %"struct.rally::game::RaceCar"], ptr %0, i24 0, i24 %20, i32 1
  store i16 1, ptr %33, align 1, !tbaa !56
  %34 = add nuw nsw i24 %20, 1
  %35 = icmp uge i24 %34, %18
  %36 = zext i1 %35 to i24
  %37 = add nuw nsw i24 %34, %36
  %38 = trunc i24 %37 to i8
  %39 = getelementptr inbounds [6 x %"struct.rally::game::RaceCar"], ptr %0, i24 0, i24 %20, i32 2
  store i8 %38, ptr %39, align 1, !tbaa !174
  %40 = xor i24 %20, -1
  %41 = add nsw i24 %40, %18
  %42 = icmp slt i24 %41, 1
  %43 = sext i1 %42 to i24
  %44 = add nsw i24 %41, %43
  %45 = sext i24 %44 to i32
  %46 = mul nsw i32 %45, 10000
  %47 = getelementptr inbounds [6 x %"struct.rally::game::RaceCar"], ptr %0, i24 0, i24 %20, i32 3
  store i32 %46, ptr %47, align 1, !tbaa !50
  %48 = load i32, ptr %7, align 1, !tbaa !166
  %49 = srem i32 %46, %48
  %50 = icmp slt i32 %49, 0
  %51 = select i1 %50, i32 %48, i32 0
  %52 = add nsw i32 %51, %49
  %53 = getelementptr inbounds [6 x %"struct.rally::game::RaceCar"], ptr %0, i24 0, i24 %20, i32 4
  store i32 %52, ptr %53, align 1, !tbaa !47
  tail call void @_ZN5rally4game11RaceTraffic5placeEj(ptr noundef nonnull align 1 dereferenceable(197) %0, i24 noundef %20) #18
  br label %30
}

; Function Attrs: minsize mustprogress nounwind optsize
define linkonce_odr dso_local void @_ZNK5rally4game11RaceTraffic4viewERNS_7TrafficEl(ptr noundef nonnull align 1 dereferenceable(197) %0, ptr noundef nonnull align 1 dereferenceable(60) %1, i32 noundef %2) local_unnamed_addr #4 align 2 {
  br label %4

4:                                                ; preds = %15, %3
  %5 = phi i24 [ 0, %3 ], [ %23, %15 ]
  %6 = icmp eq i24 %5, 6
  br i1 %6, label %7, label %8

7:                                                ; preds = %4
  ret void

8:                                                ; preds = %4
  %9 = getelementptr inbounds [6 x %"struct.rally::game::RaceCar"], ptr %0, i24 0, i24 %5
  %10 = load i8, ptr %9, align 1, !tbaa !55, !range !34
  %11 = icmp eq i8 %10, 0
  br i1 %11, label %15, label %12

12:                                               ; preds = %8
  %13 = getelementptr inbounds [6 x %"struct.rally::game::RaceCar"], ptr %0, i24 0, i24 %5, i32 4
  %14 = load i32, ptr %13, align 1, !tbaa !47
  br label %15

15:                                               ; preds = %8, %12
  %16 = phi i32 [ %14, %12 ], [ %2, %8 ]
  %17 = getelementptr inbounds [6 x %"struct.rally::Opponent"], ptr %1, i24 0, i24 %5
  store i32 %16, ptr %17, align 1, !tbaa !136
  %18 = getelementptr inbounds [6 x %"struct.rally::game::RaceCar"], ptr %0, i24 0, i24 %5, i32 5
  %19 = load i32, ptr %18, align 1, !tbaa !175
  %20 = sdiv i32 %19, 256
  %21 = trunc i32 %20 to i24
  %22 = getelementptr inbounds [6 x %"struct.rally::Opponent"], ptr %1, i24 0, i24 %5, i32 2
  store i24 %21, ptr %22, align 1, !tbaa !144
  %23 = add nuw nsw i24 %5, 1
  br label %4, !llvm.loop !176
}

; Function Attrs: minsize mustprogress nounwind optsize
define linkonce_odr dso_local void @_ZN5rally4game11RaceTraffic5placeEj(ptr noundef nonnull align 1 dereferenceable(197) %0, i24 noundef %1) local_unnamed_addr #4 align 2 {
  %3 = and i24 %1, 1
  %4 = icmp eq i24 %3, 0
  %5 = select i1 %4, i24 1, i24 -1
  %6 = getelementptr inbounds %"struct.rally::game::RaceTraffic", ptr %0, i24 0, i32 1
  %7 = getelementptr inbounds [6 x %"struct.rally::game::RaceCar"], ptr %0, i24 0, i24 %1, i32 7
  tail call void @llvm.memcpy.p0.p0.i24(ptr noundef nonnull align 1 dereferenceable(9) %7, ptr noundef nonnull align 1 dereferenceable(9) %6, i24 9, i1 false), !tbaa.struct !170
  %8 = urem i24 %1, 3
  %9 = mul nuw nsw i24 %8, 36
  %10 = add nsw i24 %9, -36
  %11 = sext i24 %10 to i32
  %12 = shl nsw i32 %11, 8
  %13 = sext i24 %5 to i32
  %14 = getelementptr inbounds %"struct.rally::game::RaceTraffic", ptr %0, i24 0, i32 1, i32 3
  %15 = load i32, ptr %14, align 1, !tbaa !177
  %16 = add nsw i32 %15, -5044
  %17 = mul nsw i32 %16, %13
  %18 = add nsw i32 %17, %12
  %19 = getelementptr inbounds [6 x %"struct.rally::game::RaceCar"], ptr %0, i24 0, i24 %1, i32 5
  store i32 %18, ptr %19, align 1, !tbaa !175
  ret void
}

; Function Attrs: minsize mustprogress nounwind optsize
define linkonce_odr dso_local noundef i1 @_ZN5rally4game7Records6updateEjmm(ptr noundef nonnull align 1 dereferenceable(2304) %0, i24 noundef %1, i32 noundef %2, i32 noundef %3) local_unnamed_addr #4 align 2 {
  %5 = icmp ugt i24 %1, 287
  %6 = icmp ugt i32 %2, 9999999
  %7 = or i1 %5, %6
  %8 = icmp ugt i32 %3, 216000
  %9 = or i1 %7, %8
  br i1 %9, label %27, label %10

10:                                               ; preds = %4
  %11 = getelementptr inbounds [288 x %"struct.rally::game::Record"], ptr %0, i24 0, i24 %1
  %12 = load i32, ptr %11, align 1, !tbaa !102
  %13 = icmp ult i32 %12, %2
  br i1 %13, label %14, label %15

14:                                               ; preds = %10
  store i32 %2, ptr %11, align 1, !tbaa !102
  br label %15

15:                                               ; preds = %14, %10
  %16 = phi i8 [ 1, %14 ], [ 0, %10 ]
  %17 = icmp eq i32 %3, 0
  br i1 %17, label %24, label %18

18:                                               ; preds = %15
  %19 = getelementptr inbounds [288 x %"struct.rally::game::Record"], ptr %0, i24 0, i24 %1, i32 1
  %20 = load i32, ptr %19, align 1, !tbaa !178
  %21 = add i32 %20, -1
  %22 = icmp ult i32 %21, %3
  br i1 %22, label %24, label %23

23:                                               ; preds = %18
  store i32 %3, ptr %19, align 1, !tbaa !178
  br label %24

24:                                               ; preds = %18, %23, %15
  %25 = phi i8 [ 1, %23 ], [ %16, %15 ], [ %16, %18 ]
  %26 = icmp ne i8 %25, 0
  br label %27

27:                                               ; preds = %4, %24
  %28 = phi i1 [ %26, %24 ], [ false, %4 ]
  ret i1 %28
}

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize readonly willreturn
define internal fastcc noundef i1 @_ZN12_GLOBAL__N_17pressedEi(i24 noundef %0) unnamed_addr #10 {
  %2 = tail call fastcc noundef i1 @_ZN12_GLOBAL__N_13keyEi(i24 noundef %0) #18
  br i1 %2, label %3, label %13

3:                                                ; preds = %1
  %4 = add nsw i24 %0, -1
  %5 = sdiv i24 %4, 8
  %6 = getelementptr inbounds [16 x i8], ptr @_ZN12_GLOBAL__N_112previousKeysE, i24 0, i24 %5
  %7 = load i8, ptr %6, align 1, !tbaa !22
  %8 = zext i8 %7 to i24
  %9 = and i24 %4, 7
  %10 = shl nuw nsw i24 1, %9
  %11 = and i24 %10, %8
  %12 = icmp eq i24 %11, 0
  br label %13

13:                                               ; preds = %3, %1
  %14 = phi i1 [ false, %1 ], [ %12, %3 ]
  ret i1 %14
}

; Function Attrs: minsize mustprogress nounwind optsize
define linkonce_odr dso_local void @_ZN5rally4game5Rules7attemptEmNS0_8SettingsEi(ptr noundef nonnull align 1 dereferenceable(65) %0, i32 noundef %1, ptr noundef byval(%"struct.rally::game::Settings") align 1 %2, i24 noundef %3) local_unnamed_addr #4 align 2 {
  call void @llvm.memcpy.p0.p0.i24(ptr noundef nonnull align 1 dereferenceable(9) %0, ptr noundef nonnull align 1 dereferenceable(9) %2, i24 9, i1 false), !tbaa.struct !179
  %5 = getelementptr inbounds %"struct.rally::game::Rules", ptr %0, i24 0, i32 12
  store i32 %1, ptr %5, align 1, !tbaa !180
  %6 = getelementptr inbounds %"struct.rally::game::Rules", ptr %0, i24 0, i32 7
  %7 = getelementptr inbounds %"struct.rally::game::Rules", ptr %0, i24 0, i32 18
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 1 dereferenceable(16) %6, i8 0, i64 16, i1 false)
  store i8 7, ptr %7, align 1, !tbaa !66
  %8 = getelementptr inbounds %"struct.rally::game::Rules", ptr %0, i24 0, i32 17
  store i8 7, ptr %8, align 1, !tbaa !98
  %9 = getelementptr inbounds %"struct.rally::game::Rules", ptr %0, i24 0, i32 19
  store i24 %3, ptr %9, align 1, !tbaa !42
  %10 = getelementptr inbounds %"struct.rally::game::Rules", ptr %0, i24 0, i32 11
  store i32 0, ptr %10, align 1, !tbaa !52
  %11 = getelementptr inbounds %"struct.rally::game::Rules", ptr %0, i24 0, i32 4
  store i32 0, ptr %11, align 1, !tbaa !59
  %12 = getelementptr inbounds %"struct.rally::game::Rules", ptr %0, i24 0, i32 6
  store i32 0, ptr %12, align 1, !tbaa !105
  %13 = getelementptr inbounds %"struct.rally::game::Rules", ptr %0, i24 0, i32 16
  store i8 0, ptr %13, align 1, !tbaa !107
  %14 = getelementptr inbounds %"struct.rally::game::Rules", ptr %0, i24 0, i32 13
  store i32 0, ptr %14, align 1, !tbaa !181
  %15 = getelementptr inbounds %"struct.rally::game::Rules", ptr %0, i24 0, i32 15
  store i16 0, ptr %15, align 1, !tbaa !109
  %16 = load i16, ptr %0, align 1, !tbaa !182
  %17 = zext i16 %16 to i32
  %18 = mul nuw nsw i32 %17, 120
  %19 = getelementptr inbounds %"struct.rally::game::Rules", ptr %0, i24 0, i32 5
  store i32 %18, ptr %19, align 1, !tbaa !104
  %20 = getelementptr inbounds %"struct.rally::game::Rules", ptr %0, i24 0, i32 2
  store i8 2, ptr %20, align 1, !tbaa !36
  %21 = getelementptr inbounds %"struct.rally::game::Rules", ptr %0, i24 0, i32 3
  store i32 0, ptr %21, align 1, !tbaa !37
  %22 = getelementptr inbounds %"struct.rally::game::Rules", ptr %0, i24 0, i32 14
  %23 = load i16, ptr %22, align 1, !tbaa !38
  %24 = add i16 %23, 1
  store i16 %24, ptr %22, align 1, !tbaa !38
  ret void
}

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize readonly willreturn
define internal fastcc noundef i1 @_ZN12_GLOBAL__N_13keyEi(i24 noundef %0) unnamed_addr #10 {
  %2 = add nsw i24 %0, -1
  %3 = sdiv i24 %2, 8
  %4 = getelementptr inbounds [16 x i8], ptr @_ZN12_GLOBAL__N_18heldKeysE, i24 0, i24 %3
  %5 = load i8, ptr %4, align 1, !tbaa !22
  %6 = zext i8 %5 to i24
  %7 = and i24 %2, 7
  %8 = shl nuw nsw i24 1, %7
  %9 = and i24 %8, %6
  %10 = icmp ne i24 %9, 0
  ret i1 %10
}

; Function Attrs: minsize mustprogress nounwind optsize
define linkonce_odr dso_local void @_ZN5rally6Motion9gripFrameEbb(ptr noundef nonnull align 1 dereferenceable(31) %0, i1 noundef %1, i1 noundef %2) local_unnamed_addr #4 align 2 {
  %4 = xor i1 %1, %2
  br i1 %4, label %8, label %5

5:                                                ; preds = %3
  %6 = getelementptr inbounds %"struct.rally::Motion", ptr %0, i24 0, i32 8
  %7 = load i24, ptr %6, align 1, !tbaa !2
  br label %13

8:                                                ; preds = %3
  %9 = select i1 %2, i24 5, i24 -5
  %10 = getelementptr inbounds %"struct.rally::Motion", ptr %0, i24 0, i32 8
  %11 = load i24, ptr %10, align 1, !tbaa !2
  %12 = add nsw i24 %11, %9
  store i24 %12, ptr %10, align 1, !tbaa !2
  br label %13

13:                                               ; preds = %5, %8
  %14 = phi i24 [ %7, %5 ], [ %12, %8 ]
  %15 = getelementptr inbounds %"struct.rally::Motion", ptr %0, i24 0, i32 8
  %16 = icmp slt i24 %14, 25
  br i1 %16, label %19, label %17

17:                                               ; preds = %13
  %18 = icmp ugt i24 %14, 200
  br i1 %18, label %19, label %21

19:                                               ; preds = %17, %13
  %20 = phi i24 [ 25, %13 ], [ 200, %17 ]
  store i24 %20, ptr %15, align 1, !tbaa !2
  br label %21

21:                                               ; preds = %19, %17
  ret void
}

; Function Attrs: inlinehint minsize mustprogress nounwind optsize
define linkonce_odr dso_local void @_ZN5rally11trackSampleElRKNS_8TrackDefE(ptr noalias sret(%"struct.rally::Sample") align 1 %0, i32 noundef %1, ptr noundef nonnull align 1 dereferenceable(13) %2) local_unnamed_addr #3 {
  %4 = ashr i32 %1, 14
  %5 = trunc i32 %4 to i24
  %6 = getelementptr inbounds %"struct.rally::TrackDef", ptr %2, i24 0, i32 1
  %7 = load i24, ptr %6, align 1, !tbaa !183
  %8 = icmp ugt i24 %7, %5
  br i1 %8, label %11, label %9

9:                                                ; preds = %3
  %10 = urem i24 %5, %7
  br label %11

11:                                               ; preds = %9, %3
  %12 = phi i24 [ %10, %9 ], [ %5, %3 ]
  %13 = and i32 %1, 16383
  %14 = load ptr, ptr %2, align 1, !tbaa !184
  %15 = getelementptr inbounds %"struct.rally::TrackPoint", ptr %14, i24 %12
  %16 = add i24 %12, 1
  %17 = icmp eq i24 %16, %7
  %18 = select i1 %17, i24 0, i24 %16
  %19 = getelementptr inbounds %"struct.rally::TrackPoint", ptr %14, i24 %18
  %20 = load i16, ptr %15, align 1, !tbaa !185
  %21 = sext i16 %20 to i32
  %22 = shl nsw i32 %21, 8
  %23 = load i16, ptr %19, align 1, !tbaa !185
  %24 = sext i16 %23 to i24
  %25 = sext i16 %20 to i24
  %26 = sub nsw i24 %24, %25
  %27 = sext i24 %26 to i32
  %28 = mul nsw i32 %13, %27
  %29 = ashr i32 %28, 6
  %30 = add nsw i32 %29, %22
  store i32 %30, ptr %0, align 1, !tbaa !187
  %31 = getelementptr inbounds %"struct.rally::Sample", ptr %0, i24 0, i32 1
  %32 = getelementptr inbounds %"struct.rally::TrackPoint", ptr %14, i24 %12, i32 1
  %33 = load i16, ptr %32, align 1, !tbaa !188
  %34 = sext i16 %33 to i32
  %35 = shl nsw i32 %34, 8
  %36 = getelementptr inbounds %"struct.rally::TrackPoint", ptr %14, i24 %18, i32 1
  %37 = load i16, ptr %36, align 1, !tbaa !188
  %38 = sext i16 %37 to i24
  %39 = sext i16 %33 to i24
  %40 = sub nsw i24 %38, %39
  %41 = sext i24 %40 to i32
  %42 = mul nsw i32 %13, %41
  %43 = ashr i32 %42, 6
  %44 = add nsw i32 %43, %35
  store i32 %44, ptr %31, align 1, !tbaa !189
  %45 = getelementptr inbounds %"struct.rally::Sample", ptr %0, i24 0, i32 2
  %46 = getelementptr inbounds %"struct.rally::TrackPoint", ptr %14, i24 %12, i32 2
  %47 = load i16, ptr %46, align 1, !tbaa !190
  %48 = sext i16 %47 to i32
  %49 = getelementptr inbounds %"struct.rally::TrackPoint", ptr %14, i24 %18, i32 2
  %50 = load i16, ptr %49, align 1, !tbaa !190
  %51 = sext i16 %50 to i24
  %52 = sext i16 %47 to i24
  %53 = sub nsw i24 %51, %52
  %54 = sext i24 %53 to i32
  %55 = mul nsw i32 %13, %54
  %56 = ashr i32 %55, 14
  %57 = add nsw i32 %56, %48
  store i32 %57, ptr %45, align 1, !tbaa !123
  %58 = getelementptr inbounds %"struct.rally::Sample", ptr %0, i24 0, i32 3
  %59 = getelementptr inbounds %"struct.rally::TrackPoint", ptr %14, i24 %12, i32 3
  %60 = load i16, ptr %59, align 1, !tbaa !191
  %61 = sext i16 %60 to i32
  %62 = getelementptr inbounds %"struct.rally::TrackPoint", ptr %14, i24 %18, i32 3
  %63 = load i16, ptr %62, align 1, !tbaa !191
  %64 = sext i16 %63 to i24
  %65 = sext i16 %60 to i24
  %66 = sub nsw i24 %64, %65
  %67 = sext i24 %66 to i32
  %68 = mul nsw i32 %13, %67
  %69 = ashr i32 %68, 14
  %70 = add nsw i32 %69, %61
  store i32 %70, ptr %58, align 1, !tbaa !125
  ret void
}

; Function Attrs: minsize mustprogress nounwind optsize
define linkonce_odr dso_local void @_ZNK5rally10DemoDriver4tickERNS_6MotionE(ptr noundef nonnull align 1 dereferenceable(3) %0, ptr noundef nonnull align 1 dereferenceable(31) %1) local_unnamed_addr #4 align 2 {
  %3 = getelementptr inbounds %"struct.rally::Motion", ptr %1, i24 0, i32 3
  %4 = load i32, ptr %3, align 1, !tbaa !44
  %5 = load i24, ptr %0, align 1, !tbaa !128
  %6 = sext i24 %5 to i32
  %7 = icmp slt i32 %4, %6
  %8 = add nsw i24 %5, 2
  %9 = sext i24 %8 to i32
  %10 = icmp sgt i32 %4, %9
  tail call void @_ZN5rally6Motion4tickEbb(ptr noundef nonnull align 1 dereferenceable(31) %1, i1 noundef %7, i1 noundef %10) #18
  ret void
}

; Function Attrs: minsize mustprogress nounwind optsize
define linkonce_odr dso_local void @_ZN5rally4game11RaceTraffic4tickEmm(ptr noundef nonnull align 1 dereferenceable(197) %0, i32 noundef %1, i32 noundef %2) local_unnamed_addr #4 align 2 {
  %4 = getelementptr inbounds %"struct.rally::game::RaceTraffic", ptr %0, i24 0, i32 1
  %5 = tail call noundef i16 @_ZN5rally4game11RouteCursor4tickEv(ptr noundef nonnull align 1 dereferenceable(9) %4) #18
  %6 = zext i16 %5 to i32
  %7 = getelementptr inbounds %"struct.rally::game::RaceTraffic", ptr %0, i24 0, i32 3
  %8 = getelementptr inbounds %"struct.rally::game::RaceTraffic", ptr %0, i24 0, i32 2
  %9 = add nsw i32 %1, -12000
  %10 = getelementptr inbounds %"struct.rally::game::RaceTraffic", ptr %0, i24 0, i32 4
  br label %11

11:                                               ; preds = %47, %3
  %12 = phi i24 [ 0, %3 ], [ %48, %47 ]
  %13 = icmp eq i24 %12, 6
  br i1 %13, label %14, label %17

14:                                               ; preds = %11
  %15 = load i8, ptr %8, align 1, !tbaa !164
  %16 = icmp eq i8 %15, 1
  br i1 %16, label %49, label %58

17:                                               ; preds = %11
  %18 = getelementptr inbounds [6 x %"struct.rally::game::RaceCar"], ptr %0, i24 0, i24 %12
  %19 = load i8, ptr %18, align 1, !tbaa !55, !range !34
  %20 = icmp eq i8 %19, 0
  br i1 %20, label %47, label %21

21:                                               ; preds = %17
  %22 = getelementptr inbounds [6 x %"struct.rally::game::RaceCar"], ptr %0, i24 0, i24 %12, i32 3
  %23 = load i32, ptr %22, align 1, !tbaa !50
  %24 = add nsw i32 %23, %6
  store i32 %24, ptr %22, align 1, !tbaa !50
  %25 = getelementptr inbounds [6 x %"struct.rally::game::RaceCar"], ptr %0, i24 0, i24 %12, i32 4
  %26 = load i32, ptr %25, align 1, !tbaa !47
  %27 = add nsw i32 %26, %6
  store i32 %27, ptr %25, align 1, !tbaa !47
  %28 = load i32, ptr %7, align 1, !tbaa !166
  %29 = icmp slt i32 %27, %28
  br i1 %29, label %32, label %30

30:                                               ; preds = %21
  %31 = sub nsw i32 %27, %28
  store i32 %31, ptr %25, align 1, !tbaa !47
  br label %32

32:                                               ; preds = %30, %21
  tail call void @_ZN5rally4game11RaceTraffic5placeEj(ptr noundef nonnull align 1 dereferenceable(197) %0, i24 noundef %12) #18
  %33 = load i8, ptr %8, align 1, !tbaa !164
  switch i8 %33, label %47 [
    i8 0, label %34
    i8 1, label %43
  ]

34:                                               ; preds = %32
  %35 = getelementptr inbounds [6 x %"struct.rally::game::RaceCar"], ptr %0, i24 0, i24 %12, i32 6
  %36 = load i32, ptr %35, align 1, !tbaa !51
  %37 = icmp eq i32 %36, 0
  br i1 %37, label %38, label %47

38:                                               ; preds = %34
  %39 = load i32, ptr %22, align 1, !tbaa !50
  %40 = load i32, ptr %10, align 1, !tbaa !167
  %41 = icmp slt i32 %39, %40
  br i1 %41, label %47, label %42

42:                                               ; preds = %38
  store i32 %2, ptr %35, align 1, !tbaa !51
  br label %47

43:                                               ; preds = %32
  %44 = load i32, ptr %22, align 1, !tbaa !50
  %45 = icmp slt i32 %44, %9
  br i1 %45, label %46, label %47

46:                                               ; preds = %43
  store i8 0, ptr %18, align 1, !tbaa !55
  br label %47

47:                                               ; preds = %32, %34, %38, %42, %43, %46, %17
  %48 = add nuw nsw i24 %12, 1
  br label %11, !llvm.loop !192

49:                                               ; preds = %14
  %50 = getelementptr inbounds %"struct.rally::game::RaceTraffic", ptr %0, i24 0, i32 5
  %51 = load i32, ptr %50, align 1, !tbaa !168
  %52 = icmp ugt i32 %51, %1
  br i1 %52, label %58, label %53

53:                                               ; preds = %49
  %54 = add nsw i32 %1, 60000
  %55 = tail call noundef i1 @_ZN5rally4game11RaceTraffic5spawnEl(ptr noundef nonnull align 1 dereferenceable(197) %0, i32 noundef %54) #18
  %56 = load i32, ptr %50, align 1, !tbaa !168
  %57 = add i32 %56, 90000
  store i32 %57, ptr %50, align 1, !tbaa !168
  br label %58

58:                                               ; preds = %53, %49, %14
  ret void
}

; Function Attrs: minsize mustprogress nounwind optsize
define linkonce_odr dso_local noundef i1 @_ZN5rally4game5Crash4tickERNS_6MotionERKNS0_11RaceTrafficEm(ptr noundef nonnull align 1 dereferenceable(4) %0, ptr noundef nonnull align 1 dereferenceable(31) %1, ptr noundef nonnull align 1 dereferenceable(197) %2, i32 noundef %3) local_unnamed_addr #4 align 2 {
  %5 = load i16, ptr %0, align 1, !tbaa !61
  %6 = icmp eq i16 %5, 0
  br i1 %6, label %7, label %13

7:                                                ; preds = %4
  %8 = getelementptr inbounds %"struct.rally::game::Crash", ptr %0, i24 0, i32 1
  %9 = load i16, ptr %8, align 1, !tbaa !94
  %10 = icmp eq i16 %9, 0
  br i1 %10, label %33, label %11

11:                                               ; preds = %7
  %12 = add i16 %9, -1
  store i16 %12, ptr %8, align 1, !tbaa !94
  br label %33

13:                                               ; preds = %4
  %14 = getelementptr inbounds %"struct.rally::Motion", ptr %1, i24 0, i32 3
  store i32 0, ptr %14, align 1, !tbaa !44
  %15 = getelementptr inbounds %"struct.rally::Motion", ptr %1, i24 0, i32 5
  store i32 0, ptr %15, align 1, !tbaa !63
  %16 = icmp eq i16 %5, 1
  br i1 %16, label %19, label %17

17:                                               ; preds = %13
  %18 = add i16 %5, -1
  store i16 %18, ptr %0, align 1, !tbaa !61
  br label %33

19:                                               ; preds = %13, %22
  %20 = phi i24 [ %28, %22 ], [ 0, %13 ]
  %21 = icmp eq i24 %20, 5
  br i1 %21, label %33, label %22

22:                                               ; preds = %19
  %23 = getelementptr inbounds i24, ptr @__const._ZN5rally4game5Crash4tickERNS_6MotionERKNS0_11RaceTrafficEm.lanes, i24 %20
  %24 = load i24, ptr %23, align 1, !tbaa !92
  %25 = sext i24 %24 to i32
  %26 = shl nsw i32 %25, 8
  %27 = tail call noundef i1 @_ZNK5rally4game11RaceTraffic7contactEml(ptr noundef nonnull align 1 dereferenceable(197) %2, i32 noundef %3, i32 noundef %26) #18
  %28 = add nuw nsw i24 %20, 1
  br i1 %27, label %19, label %29

29:                                               ; preds = %22
  %30 = getelementptr inbounds %"struct.rally::Motion", ptr %1, i24 0, i32 4
  store i32 %26, ptr %30, align 1, !tbaa !60
  %31 = getelementptr inbounds %"struct.rally::Motion", ptr %1, i24 0, i32 6
  store i16 0, ptr %31, align 1, !tbaa !41
  store i16 0, ptr %0, align 1, !tbaa !61
  %32 = getelementptr inbounds %"struct.rally::game::Crash", ptr %0, i24 0, i32 1
  store i16 120, ptr %32, align 1, !tbaa !94
  br label %33

33:                                               ; preds = %19, %29, %7, %11, %17
  %34 = xor i1 %6, true
  ret i1 %34
}

; Function Attrs: minsize mustprogress nounwind optsize
define linkonce_odr dso_local void @_ZN5rally6Motion4tickEbb(ptr noundef nonnull align 1 dereferenceable(31) %0, i1 noundef %1, i1 noundef %2) local_unnamed_addr #4 align 2 {
  %4 = alloca %"struct.rally::Sample", align 1
  %5 = alloca %"struct.rally::Sample", align 1
  tail call void @_ZN5rally6Motion9speedStepEbb(ptr noundef nonnull align 1 dereferenceable(31) %0, i1 noundef %1, i1 noundef %2) #18
  %6 = getelementptr inbounds %"struct.rally::Motion", ptr %0, i24 0, i32 2
  %7 = load i32, ptr %6, align 1, !tbaa !53
  %8 = freeze i32 %7
  %9 = sdiv i32 %8, 100
  %10 = shl nsw i32 %9, 8
  %11 = mul i32 %9, 100
  %12 = sub i32 %8, %11
  %13 = shl nsw i32 %12, 8
  %14 = sdiv i32 %13, 100
  %15 = add nsw i32 %14, %10
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %4) #19
  %16 = load ptr, ptr %0, align 1, !tbaa !113
  call void @_ZN5rally11trackSampleElRKNS_8TrackDefE(ptr nonnull sret(%"struct.rally::Sample") align 1 %4, i32 noundef %15, ptr noundef nonnull align 1 dereferenceable(13) %16) #18
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %5) #19
  %17 = add nsw i32 %15, 16384
  %18 = load ptr, ptr %0, align 1, !tbaa !113
  call void @_ZN5rally11trackSampleElRKNS_8TrackDefE(ptr nonnull sret(%"struct.rally::Sample") align 1 %5, i32 noundef %17, ptr noundef nonnull align 1 dereferenceable(13) %18) #18
  %19 = getelementptr inbounds %"struct.rally::Sample", ptr %4, i24 0, i32 2
  %20 = load i32, ptr %19, align 1, !tbaa !123
  %21 = getelementptr inbounds %"struct.rally::Sample", ptr %5, i24 0, i32 3
  %22 = load i32, ptr %21, align 1, !tbaa !125
  %23 = mul nsw i32 %22, %20
  %24 = getelementptr inbounds %"struct.rally::Sample", ptr %4, i24 0, i32 3
  %25 = load i32, ptr %24, align 1, !tbaa !125
  %26 = getelementptr inbounds %"struct.rally::Sample", ptr %5, i24 0, i32 2
  %27 = load i32, ptr %26, align 1, !tbaa !123
  %28 = mul nsw i32 %27, %25
  %29 = sub nsw i32 %23, %28
  %30 = sdiv i32 %29, 4096
  %31 = getelementptr inbounds %"struct.rally::Motion", ptr %0, i24 0, i32 3
  %32 = load i32, ptr %31, align 1, !tbaa !44
  %33 = mul nsw i32 %32, %32
  %34 = mul nsw i32 %33, %30
  %35 = sdiv i32 %34, 1024
  call void @_ZN5rally6Motion11lateralStepEl(ptr noundef nonnull align 1 dereferenceable(31) %0, i32 noundef %35) #18
  %36 = getelementptr inbounds %"struct.rally::Motion", ptr %0, i24 0, i32 5
  %37 = load i32, ptr %36, align 1, !tbaa !63
  %38 = sdiv i32 %37, 100
  %39 = getelementptr inbounds %"struct.rally::Motion", ptr %0, i24 0, i32 4
  %40 = load i32, ptr %39, align 1, !tbaa !60
  %41 = add nsw i32 %40, %38
  store i32 %41, ptr %39, align 1, !tbaa !60
  %42 = icmp sgt i32 %41, 38400
  br i1 %42, label %45, label %43

43:                                               ; preds = %3
  %44 = icmp slt i32 %41, -38400
  br i1 %44, label %45, label %47

45:                                               ; preds = %43, %3
  %46 = phi i32 [ 38400, %3 ], [ -38400, %43 ]
  store i32 %46, ptr %39, align 1, !tbaa !60
  store i32 0, ptr %36, align 1, !tbaa !63
  br label %47

47:                                               ; preds = %45, %43
  %48 = load i32, ptr %6, align 1, !tbaa !53
  %49 = load i32, ptr %31, align 1, !tbaa !44
  %50 = shl nsw i32 %49, 1
  %51 = add nsw i32 %50, %48
  %52 = load ptr, ptr %0, align 1, !tbaa !113
  %53 = getelementptr inbounds %"struct.rally::TrackDef", ptr %52, i24 0, i32 2
  %54 = load i32, ptr %53, align 1, !tbaa !39
  %55 = mul nsw i32 %54, 100
  %56 = srem i32 %51, %55
  store i32 %56, ptr %6, align 1, !tbaa !53
  %57 = getelementptr inbounds %"struct.rally::Motion", ptr %0, i24 0, i32 1
  %58 = load i32, ptr %57, align 1, !tbaa !130
  %59 = add nsw i32 %58, %50
  %60 = srem i32 %59, 8000
  store i32 %60, ptr %57, align 1, !tbaa !130
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %5) #19
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %4) #19
  ret void
}

; Function Attrs: minsize mustprogress nounwind optsize
define linkonce_odr dso_local noundef i1 @_ZNK5rally4game11RaceTraffic14contactStationEll(ptr noundef nonnull align 1 dereferenceable(197) %0, i32 noundef %1, i32 noundef %2) local_unnamed_addr #4 align 2 {
  %4 = getelementptr inbounds %"struct.rally::game::RaceTraffic", ptr %0, i24 0, i32 3
  %5 = load i32, ptr %4, align 1
  %6 = sdiv i32 %5, 2
  %7 = sdiv i32 %5, -2
  %8 = sub i32 0, %5
  br label %9

9:                                                ; preds = %33, %3
  %10 = phi i24 [ 0, %3 ], [ %34, %33 ]
  %11 = icmp eq i24 %10, 6
  br i1 %11, label %35, label %12

12:                                               ; preds = %9
  %13 = getelementptr inbounds %"struct.rally::game::RaceCar", ptr %0, i24 %10
  %14 = load i8, ptr %13, align 1, !tbaa !55, !range !34
  %15 = icmp eq i8 %14, 0
  br i1 %15, label %33, label %16

16:                                               ; preds = %12
  %17 = getelementptr inbounds %"struct.rally::game::RaceCar", ptr %0, i24 %10, i32 4
  %18 = load i32, ptr %17, align 1, !tbaa !47
  %19 = sub nsw i32 %18, %1
  %20 = icmp sgt i32 %19, %6
  %21 = icmp slt i32 %19, %7
  %22 = select i1 %21, i32 %5, i32 0
  %23 = select i1 %20, i32 %8, i32 %22
  %24 = add i32 %19, %23
  %25 = tail call i32 @llvm.abs.i32(i32 %24, i1 true)
  %26 = icmp ult i32 %25, 3200
  br i1 %26, label %27, label %33

27:                                               ; preds = %16
  %28 = getelementptr inbounds %"struct.rally::game::RaceCar", ptr %0, i24 %10, i32 5
  %29 = load i32, ptr %28, align 1, !tbaa !175
  %30 = sub nsw i32 %29, %2
  %31 = tail call i32 @llvm.abs.i32(i32 %30, i1 true)
  %32 = icmp ult i32 %31, 6144
  br i1 %32, label %35, label %33

33:                                               ; preds = %27, %16, %12
  %34 = add nuw nsw i24 %10, 1
  br label %9

35:                                               ; preds = %27, %9
  %36 = xor i1 %11, true
  ret i1 %36
}

; Function Attrs: minsize mustprogress nounwind optsize
define linkonce_odr dso_local noundef i8 @_ZNK5rally4game11RaceTraffic4rankEmm(ptr noundef nonnull align 1 dereferenceable(197) %0, i32 noundef %1, i32 noundef %2) local_unnamed_addr #4 align 2 {
  %4 = icmp eq i32 %2, 0
  %5 = getelementptr inbounds %"struct.rally::game::RaceTraffic", ptr %0, i24 0, i32 6
  %6 = load i8, ptr %5, align 1
  br label %7

7:                                                ; preds = %36, %3
  %8 = phi i24 [ 0, %3 ], [ %38, %36 ]
  %9 = phi i24 [ 1, %3 ], [ %37, %36 ]
  %10 = icmp eq i24 %8, 6
  br i1 %10, label %11, label %13

11:                                               ; preds = %7
  %12 = trunc i24 %9 to i8
  ret i8 %12

13:                                               ; preds = %7
  %14 = getelementptr inbounds %"struct.rally::game::RaceCar", ptr %0, i24 %8
  %15 = load i8, ptr %14, align 1, !tbaa !55, !range !34
  %16 = icmp eq i8 %15, 0
  br i1 %16, label %36, label %17

17:                                               ; preds = %13
  br i1 %4, label %30, label %18

18:                                               ; preds = %17
  %19 = getelementptr inbounds %"struct.rally::game::RaceCar", ptr %0, i24 %8, i32 6
  %20 = load i32, ptr %19, align 1, !tbaa !51
  %21 = icmp eq i32 %20, 0
  br i1 %21, label %36, label %22

22:                                               ; preds = %18
  %23 = icmp ult i32 %20, %2
  br i1 %23, label %34, label %24

24:                                               ; preds = %22
  %25 = icmp eq i32 %20, %2
  br i1 %25, label %26, label %36

26:                                               ; preds = %24
  %27 = getelementptr inbounds %"struct.rally::game::RaceCar", ptr %0, i24 %8, i32 2
  %28 = load i8, ptr %27, align 1, !tbaa !174
  %29 = icmp ult i8 %28, %6
  br i1 %29, label %34, label %36

30:                                               ; preds = %17
  %31 = getelementptr inbounds %"struct.rally::game::RaceCar", ptr %0, i24 %8, i32 3
  %32 = load i32, ptr %31, align 1, !tbaa !50
  %33 = icmp sgt i32 %32, %1
  br i1 %33, label %34, label %36

34:                                               ; preds = %30, %26, %22
  %35 = add i24 %9, 1
  br label %36

36:                                               ; preds = %18, %24, %26, %30, %34, %13
  %37 = phi i24 [ %35, %34 ], [ %9, %26 ], [ %9, %24 ], [ %9, %18 ], [ %9, %30 ], [ %9, %13 ]
  %38 = add nuw nsw i24 %8, 1
  br label %7
}

; Function Attrs: minsize mustprogress nounwind optsize
define linkonce_odr dso_local void @_ZN5rally4game5Rules4tickEm(ptr noundef nonnull align 1 dereferenceable(65) %0, i32 noundef %1) local_unnamed_addr #4 align 2 {
  %3 = getelementptr inbounds %"struct.rally::game::Rules", ptr %0, i24 0, i32 3
  %4 = load i32, ptr %3, align 1, !tbaa !37
  %5 = add i32 %4, 1
  store i32 %5, ptr %3, align 1, !tbaa !37
  %6 = getelementptr inbounds %"struct.rally::game::Rules", ptr %0, i24 0, i32 15
  %7 = load i16, ptr %6, align 1, !tbaa !109
  %8 = icmp eq i16 %7, 0
  br i1 %8, label %11, label %9

9:                                                ; preds = %2
  %10 = add i16 %7, -1
  store i16 %10, ptr %6, align 1, !tbaa !109
  br label %11

11:                                               ; preds = %9, %2
  %12 = getelementptr inbounds %"struct.rally::game::Rules", ptr %0, i24 0, i32 2
  %13 = load i8, ptr %12, align 1, !tbaa !36
  switch i8 %13, label %25 [
    i8 2, label %14
    i8 5, label %14
    i8 4, label %22
  ]

14:                                               ; preds = %11, %11
  %15 = icmp eq i32 %5, 360
  br i1 %15, label %16, label %134

16:                                               ; preds = %14
  %17 = icmp eq i8 %13, 2
  %18 = select i1 %17, i8 3, i8 6
  store i8 %18, ptr %12, align 1, !tbaa !36
  store i32 0, ptr %3, align 1, !tbaa !37
  %19 = getelementptr inbounds %"struct.rally::game::Rules", ptr %0, i24 0, i32 14
  %20 = load i16, ptr %19, align 1, !tbaa !38
  %21 = add i16 %20, 1
  store i16 %21, ptr %19, align 1, !tbaa !38
  br label %134

22:                                               ; preds = %11
  %23 = icmp eq i32 %5, 480
  br i1 %23, label %24, label %134

24:                                               ; preds = %22
  tail call void @_ZN5rally4game5Rules9raceReadyEv(ptr noundef nonnull align 1 dereferenceable(65) %0) #18
  br label %134

25:                                               ; preds = %11
  %26 = add i8 %13, -7
  %27 = icmp ult i8 %26, 3
  br i1 %27, label %28, label %34

28:                                               ; preds = %25
  %29 = icmp eq i32 %5, 1440
  br i1 %29, label %30, label %134

30:                                               ; preds = %28
  store i8 0, ptr %12, align 1, !tbaa !36
  store i32 0, ptr %3, align 1, !tbaa !37
  %31 = getelementptr inbounds %"struct.rally::game::Rules", ptr %0, i24 0, i32 14
  %32 = load i16, ptr %31, align 1, !tbaa !38
  %33 = add i16 %32, 1
  store i16 %33, ptr %31, align 1, !tbaa !38
  br label %134

34:                                               ; preds = %25
  %35 = icmp eq i8 %13, 3
  switch i8 %13, label %134 [
    i8 6, label %36
    i8 3, label %36
  ]

36:                                               ; preds = %34, %34
  %37 = getelementptr inbounds %"struct.rally::game::Rules", ptr %0, i24 0, i32 4
  %38 = load i32, ptr %37, align 1, !tbaa !59
  %39 = add i32 %38, 1
  store i32 %39, ptr %37, align 1, !tbaa !59
  %40 = getelementptr inbounds %"struct.rally::game::Rules", ptr %0, i24 0, i32 5
  %41 = load i32, ptr %40, align 1, !tbaa !104
  %42 = icmp eq i32 %41, 0
  br i1 %42, label %45, label %43

43:                                               ; preds = %36
  %44 = add i32 %41, -1
  store i32 %44, ptr %40, align 1, !tbaa !104
  br label %45

45:                                               ; preds = %43, %36
  %46 = phi i32 [ %44, %43 ], [ 0, %36 ]
  %47 = getelementptr inbounds %"struct.rally::game::Rules", ptr %0, i24 0, i32 11
  %48 = load i32, ptr %47, align 1, !tbaa !52
  %49 = add i32 %48, %1
  store i32 %49, ptr %47, align 1, !tbaa !52
  %50 = getelementptr inbounds %"struct.rally::game::Rules", ptr %0, i24 0, i32 13
  %51 = load i32, ptr %50, align 1, !tbaa !181
  %52 = add i32 %51, %1
  %53 = freeze i32 %52
  %54 = udiv i32 %53, 1600
  %55 = getelementptr inbounds %"struct.rally::game::Rules", ptr %0, i24 0, i32 10
  %56 = load i32, ptr %55, align 1, !tbaa !64
  %57 = sub i32 9999999, %56
  %58 = icmp ult i32 %57, %54
  %59 = add i32 %56, %54
  %60 = select i1 %58, i32 9999999, i32 %59
  store i32 %60, ptr %55, align 1, !tbaa !64
  %61 = mul i32 %54, 1600
  %62 = sub i32 %53, %61
  store i32 %62, ptr %50, align 1, !tbaa !181
  %63 = getelementptr inbounds %"struct.rally::game::Rules", ptr %0, i24 0, i32 16
  %64 = load i8, ptr %63, align 1, !tbaa !107
  %65 = zext i8 %64 to i24
  %66 = add nuw nsw i24 %65, 1
  %67 = zext i24 %66 to i32
  %68 = getelementptr inbounds %"struct.rally::game::Rules", ptr %0, i24 0, i32 12
  %69 = load i32, ptr %68, align 1, !tbaa !180
  %70 = mul i32 %69, %67
  %71 = icmp ult i32 %49, %70
  br i1 %71, label %126, label %72

72:                                               ; preds = %45
  %73 = add i8 %64, 1
  store i8 %73, ptr %63, align 1, !tbaa !107
  %74 = getelementptr inbounds %"struct.rally::game::Rules", ptr %0, i24 0, i32 6
  %75 = load i32, ptr %74, align 1, !tbaa !105
  %76 = sub i32 %39, %75
  %77 = getelementptr inbounds %"struct.rally::game::Rules", ptr %0, i24 0, i32 7
  store i32 %76, ptr %77, align 1, !tbaa !106
  store i32 %39, ptr %74, align 1, !tbaa !105
  %78 = getelementptr inbounds %"struct.rally::game::Rules", ptr %0, i24 0, i32 8
  %79 = load i32, ptr %78, align 1, !tbaa !101
  %80 = icmp eq i32 %79, 0
  %81 = icmp ult i32 %76, %79
  %82 = select i1 %80, i1 true, i1 %81
  br i1 %82, label %83, label %84

83:                                               ; preds = %72
  store i32 %76, ptr %78, align 1, !tbaa !101
  br label %84

84:                                               ; preds = %72, %83
  %85 = add i32 %60, -9999000
  %86 = icmp ult i32 %85, 1000
  %87 = add i32 %60, 1000
  %88 = select i1 %86, i32 9999999, i32 %87
  store i32 %88, ptr %55, align 1, !tbaa !64
  br i1 %35, label %89, label %106

89:                                               ; preds = %84
  %90 = getelementptr inbounds %"struct.rally::game::Rules", ptr %0, i24 0, i32 9
  store i32 %39, ptr %90, align 1, !tbaa !193
  %91 = tail call noundef i8 @_ZNK5rally4game5Rules14qualifyingGridEm(ptr noundef nonnull align 1 dereferenceable(65) %0, i32 noundef %39) #18
  %92 = getelementptr inbounds %"struct.rally::game::Rules", ptr %0, i24 0, i32 17
  store i8 %91, ptr %92, align 1, !tbaa !98
  %93 = getelementptr inbounds %"struct.rally::game::Rules", ptr %0, i24 0, i32 18
  store i8 %91, ptr %93, align 1, !tbaa !66
  %94 = zext i8 %91 to i24
  %95 = sub nsw i24 8, %94
  %96 = mul nsw i24 %95, 500
  %97 = sext i24 %96 to i32
  %98 = load i32, ptr %55, align 1, !tbaa !64
  %99 = sub i32 9999999, %98
  %100 = icmp ult i32 %99, %97
  %101 = add i32 %98, %97
  %102 = select i1 %100, i32 9999999, i32 %101
  store i32 %102, ptr %55, align 1, !tbaa !64
  store i8 4, ptr %12, align 1, !tbaa !36
  store i32 0, ptr %3, align 1, !tbaa !37
  %103 = getelementptr inbounds %"struct.rally::game::Rules", ptr %0, i24 0, i32 14
  %104 = load i16, ptr %103, align 1, !tbaa !38
  %105 = add i16 %104, 1
  store i16 %105, ptr %103, align 1, !tbaa !38
  br label %134

106:                                              ; preds = %84
  %107 = getelementptr inbounds %"struct.rally::game::Settings", ptr %0, i24 0, i32 4
  %108 = load i8, ptr %107, align 1, !tbaa !108
  %109 = icmp eq i8 %73, %108
  br i1 %109, label %110, label %120

110:                                              ; preds = %106
  %111 = udiv i32 %46, 120
  %112 = mul nuw i32 %111, 100
  %113 = sub i32 9999999, %88
  %114 = icmp ult i32 %113, %112
  %115 = add i32 %112, %88
  %116 = select i1 %114, i32 9999999, i32 %115
  store i32 %116, ptr %55, align 1, !tbaa !64
  store i8 7, ptr %12, align 1, !tbaa !36
  store i32 0, ptr %3, align 1, !tbaa !37
  %117 = getelementptr inbounds %"struct.rally::game::Rules", ptr %0, i24 0, i32 14
  %118 = load i16, ptr %117, align 1, !tbaa !38
  %119 = add i16 %118, 1
  store i16 %119, ptr %117, align 1, !tbaa !38
  br label %134

120:                                              ; preds = %106
  %121 = getelementptr inbounds %"struct.rally::game::Settings", ptr %0, i24 0, i32 3
  %122 = load i16, ptr %121, align 1, !tbaa !194
  %123 = zext i16 %122 to i32
  %124 = mul nuw nsw i32 %123, 120
  %125 = add i32 %124, %46
  store i32 %125, ptr %40, align 1, !tbaa !104
  store i16 240, ptr %6, align 1, !tbaa !109
  br label %126

126:                                              ; preds = %45, %120
  %127 = phi i32 [ %125, %120 ], [ %46, %45 ]
  %128 = icmp eq i32 %127, 0
  br i1 %128, label %129, label %134

129:                                              ; preds = %126
  %130 = select i1 %35, i8 9, i8 8
  store i8 %130, ptr %12, align 1, !tbaa !36
  store i32 0, ptr %3, align 1, !tbaa !37
  %131 = getelementptr inbounds %"struct.rally::game::Rules", ptr %0, i24 0, i32 14
  %132 = load i16, ptr %131, align 1, !tbaa !38
  %133 = add i16 %132, 1
  store i16 %133, ptr %131, align 1, !tbaa !38
  br label %134

134:                                              ; preds = %34, %28, %30, %22, %24, %14, %16, %89, %110, %129, %126
  ret void
}

; Function Attrs: minsize mustprogress nounwind optsize
define linkonce_odr dso_local noundef i16 @_ZN5rally4game11RouteCursor4tickEv(ptr noundef nonnull align 1 dereferenceable(9) %0) local_unnamed_addr #4 align 2 {
  %2 = getelementptr inbounds %"struct.rally::game::RouteCursor", ptr %0, i24 0, i32 1
  %3 = load i16, ptr %2, align 1, !tbaa !195
  %4 = icmp eq i16 %3, 0
  %5 = load i8, ptr %0, align 1, !tbaa !196
  br i1 %4, label %8, label %6

6:                                                ; preds = %1
  %7 = getelementptr inbounds %"struct.rally::game::RouteCursor", ptr %0, i24 0, i32 2
  br label %17

8:                                                ; preds = %1
  %9 = zext i8 %5 to i16
  %10 = add nuw nsw i16 %9, 1
  %11 = urem i16 %10, 6
  %12 = trunc i16 %11 to i8
  store i8 %12, ptr %0, align 1, !tbaa !196
  %13 = zext i16 %11 to i24
  %14 = getelementptr inbounds [6 x %"struct.rally::game::RouteRecord"], ptr @_ZN5rally4gameL5RouteE, i24 0, i24 %13
  %15 = load i16, ptr %14, align 1, !tbaa !197
  store i16 %15, ptr %2, align 1, !tbaa !195
  %16 = getelementptr inbounds [6 x %"struct.rally::game::RouteRecord"], ptr @_ZN5rally4gameL5RouteE, i24 0, i24 %13, i32 2
  br label %17

17:                                               ; preds = %6, %8
  %18 = phi ptr [ %7, %6 ], [ %16, %8 ]
  %19 = phi i8 [ %5, %6 ], [ %12, %8 ]
  %20 = load i16, ptr %18, align 1, !tbaa !57
  %21 = zext i8 %19 to i24
  %22 = getelementptr inbounds [6 x %"struct.rally::game::RouteRecord"], ptr @_ZN5rally4gameL5RouteE, i24 0, i24 %21, i32 3
  %23 = load i16, ptr %22, align 1, !tbaa !199
  %24 = getelementptr inbounds %"struct.rally::game::RouteCursor", ptr %0, i24 0, i32 2
  %25 = add i16 %20, %23
  store i16 %25, ptr %24, align 1, !tbaa !200
  %26 = getelementptr inbounds [6 x %"struct.rally::game::RouteRecord"], ptr @_ZN5rally4gameL5RouteE, i24 0, i24 %21, i32 1
  %27 = load i16, ptr %26, align 1, !tbaa !201
  %28 = zext i16 %27 to i32
  %29 = shl nuw nsw i32 %28, 1
  %30 = tail call noundef i16 @_ZN5rally4game9routeSineEs(i16 noundef %25) #18
  %31 = sext i16 %30 to i32
  %32 = mul nsw i32 %29, %31
  %33 = sdiv i32 %32, 12800
  %34 = getelementptr inbounds %"struct.rally::game::RouteCursor", ptr %0, i24 0, i32 3
  %35 = load i32, ptr %34, align 1, !tbaa !202
  %36 = add nsw i32 %33, %35
  store i32 %36, ptr %34, align 1, !tbaa !202
  %37 = load i16, ptr %2, align 1, !tbaa !195
  %38 = add i16 %37, -1
  store i16 %38, ptr %2, align 1, !tbaa !195
  %39 = shl i16 %27, 1
  ret i16 %39
}

; Function Attrs: minsize mustprogress nounwind optsize
define linkonce_odr dso_local noundef i1 @_ZN5rally4game11RaceTraffic5spawnEl(ptr noundef nonnull align 1 dereferenceable(197) %0, i32 noundef %1) local_unnamed_addr #4 align 2 {
  %3 = getelementptr inbounds %"struct.rally::game::RaceTraffic", ptr %0, i24 0, i32 2
  %4 = load i8, ptr %3, align 1, !tbaa !164
  %5 = icmp eq i8 %4, 1
  br i1 %5, label %6, label %51

6:                                                ; preds = %2
  %7 = getelementptr inbounds %"struct.rally::game::RaceTraffic", ptr %0, i24 0, i32 3
  %8 = load i32, ptr %7, align 1
  %9 = sdiv i32 %8, 2
  br label %10

10:                                               ; preds = %6, %34
  %11 = phi i24 [ %35, %34 ], [ -1, %6 ]
  %12 = phi i24 [ %36, %34 ], [ 0, %6 ]
  %13 = icmp eq i24 %12, 6
  br i1 %13, label %37, label %14

14:                                               ; preds = %10
  %15 = getelementptr inbounds [6 x %"struct.rally::game::RaceCar"], ptr %0, i24 0, i24 %12
  %16 = load i8, ptr %15, align 1, !tbaa !55, !range !34
  %17 = icmp eq i8 %16, 0
  br i1 %17, label %18, label %21

18:                                               ; preds = %14
  %19 = icmp slt i24 %11, 0
  %20 = select i1 %19, i24 %12, i24 %11
  br label %34

21:                                               ; preds = %14
  %22 = getelementptr inbounds [6 x %"struct.rally::game::RaceCar"], ptr %0, i24 0, i24 %12, i32 3
  %23 = load i32, ptr %22, align 1, !tbaa !50
  %24 = sub nsw i32 %23, %1
  %25 = srem i32 %24, %8
  %26 = icmp slt i32 %25, 0
  %27 = select i1 %26, i32 %8, i32 0
  %28 = add nsw i32 %27, %25
  %29 = icmp sgt i32 %28, %9
  %30 = select i1 %29, i32 %8, i32 0
  %31 = sub nsw i32 %28, %30
  %32 = tail call i32 @llvm.abs.i32(i32 %31, i1 true)
  %33 = icmp ult i32 %32, 9600
  br i1 %33, label %51, label %34

34:                                               ; preds = %18, %21
  %35 = phi i24 [ %11, %21 ], [ %20, %18 ]
  %36 = add nuw nsw i24 %12, 1
  br label %10, !llvm.loop !203

37:                                               ; preds = %10
  %38 = icmp slt i24 %11, 0
  br i1 %38, label %51, label %39

39:                                               ; preds = %37
  %40 = getelementptr inbounds [6 x %"struct.rally::game::RaceCar"], ptr %0, i24 0, i24 %11
  %41 = getelementptr inbounds [6 x %"struct.rally::game::RaceCar"], ptr %0, i24 0, i24 %11, i32 1
  %42 = load i16, ptr %41, align 1, !tbaa !56
  %43 = add i16 %42, 1
  store i16 %43, ptr %41, align 1, !tbaa !56
  store i8 1, ptr %40, align 1, !tbaa !55
  %44 = getelementptr inbounds [6 x %"struct.rally::game::RaceCar"], ptr %0, i24 0, i24 %11, i32 3
  store i32 %1, ptr %44, align 1, !tbaa !50
  %45 = srem i32 %1, %8
  %46 = icmp slt i32 %45, 0
  %47 = select i1 %46, i32 %8, i32 0
  %48 = add nsw i32 %47, %45
  %49 = getelementptr inbounds [6 x %"struct.rally::game::RaceCar"], ptr %0, i24 0, i24 %11, i32 4
  store i32 %48, ptr %49, align 1, !tbaa !47
  %50 = getelementptr inbounds [6 x %"struct.rally::game::RaceCar"], ptr %0, i24 0, i24 %11, i32 6
  store i32 0, ptr %50, align 1, !tbaa !51
  tail call void @_ZN5rally4game11RaceTraffic5placeEj(ptr noundef nonnull align 1 dereferenceable(197) %0, i24 noundef %11) #18
  br label %51

51:                                               ; preds = %21, %39, %37, %2
  %52 = phi i1 [ false, %2 ], [ true, %39 ], [ false, %37 ], [ false, %21 ]
  ret i1 %52
}

; Function Attrs: inlinehint minsize mustprogress nounwind optsize
define linkonce_odr dso_local noundef i16 @_ZN5rally4game9routeSineEs(i16 noundef %0) local_unnamed_addr #3 {
  %2 = tail call i16 @llvm.abs.i16(i16 %0, i1 false)
  %3 = zext i16 %2 to i32
  %4 = icmp ugt i16 %2, 16384
  %5 = sub nuw nsw i32 32768, %3
  %6 = select i1 %4, i32 %5, i32 %3
  %7 = trunc i32 %6 to i24
  %8 = lshr i24 %7, 6
  %9 = getelementptr inbounds [257 x i16], ptr @_ZN5rally4gameL9RouteSineE, i24 0, i24 %8
  %10 = load i16, ptr %9, align 1, !tbaa !57
  %11 = icmp ult i24 %7, 16384
  br i1 %11, label %12, label %24

12:                                               ; preds = %1
  %13 = sext i16 %10 to i32
  %14 = and i32 %6, 63
  %15 = add nuw nsw i24 %8, 1
  %16 = getelementptr inbounds [257 x i16], ptr @_ZN5rally4gameL9RouteSineE, i24 0, i24 %15
  %17 = load i16, ptr %16, align 1, !tbaa !57
  %18 = sext i16 %17 to i32
  %19 = sub nsw i32 %18, %13
  %20 = mul nsw i32 %19, %14
  %21 = sdiv i32 %20, 64
  %22 = trunc i32 %21 to i16
  %23 = add i16 %10, %22
  br label %24

24:                                               ; preds = %12, %1
  %25 = phi i16 [ %23, %12 ], [ %10, %1 ]
  %26 = icmp slt i16 %0, 0
  %27 = sub i16 0, %25
  %28 = select i1 %26, i16 %27, i16 %25
  ret i16 %28
}

; Function Attrs: minsize mustprogress nounwind optsize
define linkonce_odr dso_local noundef i1 @_ZNK5rally4game11RaceTraffic7contactEml(ptr noundef nonnull align 1 dereferenceable(197) %0, i32 noundef %1, i32 noundef %2) local_unnamed_addr #4 align 2 {
  %4 = getelementptr inbounds %"struct.rally::game::RaceTraffic", ptr %0, i24 0, i32 3
  %5 = load i32, ptr %4, align 1, !tbaa !166
  %6 = srem i32 %1, %5
  %7 = icmp slt i32 %6, 0
  %8 = select i1 %7, i32 %5, i32 0
  %9 = add nsw i32 %8, %6
  %10 = tail call noundef i1 @_ZNK5rally4game11RaceTraffic14contactStationEll(ptr noundef nonnull align 1 dereferenceable(197) %0, i32 noundef %9, i32 noundef %2) #18
  ret i1 %10
}

; Function Attrs: minsize mustprogress nounwind optsize
define linkonce_odr dso_local void @_ZN5rally6Motion9speedStepEbb(ptr noundef nonnull align 1 dereferenceable(31) %0, i1 noundef %1, i1 noundef %2) local_unnamed_addr #4 align 2 {
  %4 = select i1 %1, i32 2, i32 0
  %5 = select i1 %2, i32 -4, i32 %4
  %6 = getelementptr inbounds %"struct.rally::Motion", ptr %0, i24 0, i32 3
  %7 = load i32, ptr %6, align 1, !tbaa !44
  %8 = add nsw i32 %7, %5
  store i32 %8, ptr %6, align 1, !tbaa !44
  %9 = getelementptr inbounds %"struct.rally::Motion", ptr %0, i24 0, i32 4
  %10 = load i32, ptr %9, align 1, !tbaa !60
  %11 = tail call i32 @llvm.abs.i32(i32 %10, i1 true)
  %12 = icmp ugt i32 %11, 24064
  %13 = icmp ult i32 %11, 19969
  br i1 %13, label %21, label %14

14:                                               ; preds = %3
  %15 = select i1 %12, i32 90, i32 160
  %16 = icmp sgt i32 %8, %15
  br i1 %16, label %17, label %21

17:                                               ; preds = %14
  %18 = select i1 %12, i32 -4, i32 -3
  %19 = add i32 %18, %8
  %20 = tail call i32 @llvm.smax.i32(i32 %19, i32 %15)
  store i32 %20, ptr %6, align 1
  br label %23

21:                                               ; preds = %14, %3
  %22 = icmp slt i32 %8, 0
  br i1 %22, label %26, label %23

23:                                               ; preds = %17, %21
  %24 = phi i32 [ %20, %17 ], [ %8, %21 ]
  %25 = icmp ugt i32 %24, 300
  br i1 %25, label %26, label %28

26:                                               ; preds = %23, %21
  %27 = phi i32 [ 0, %21 ], [ 300, %23 ]
  store i32 %27, ptr %6, align 1, !tbaa !44
  br label %28

28:                                               ; preds = %26, %23
  ret void
}

; Function Attrs: minsize mustprogress nounwind optsize
define linkonce_odr dso_local void @_ZN5rally6Motion11lateralStepEl(ptr noundef nonnull align 1 dereferenceable(31) %0, i32 noundef %1) local_unnamed_addr #4 align 2 {
  %3 = getelementptr inbounds %"struct.rally::Motion", ptr %0, i24 0, i32 6
  %4 = load i16, ptr %3, align 1, !tbaa !41
  %5 = getelementptr inbounds %"struct.rally::Motion", ptr %0, i24 0, i32 7
  %6 = load i16, ptr %5, align 1, !tbaa !54
  %7 = getelementptr inbounds %"struct.rally::Motion", ptr %0, i24 0, i32 3
  %8 = load i32, ptr %7, align 1, !tbaa !44
  %9 = getelementptr inbounds %"struct.rally::Motion", ptr %0, i24 0, i32 5
  %10 = load i32, ptr %9, align 1, !tbaa !63
  %11 = getelementptr inbounds %"struct.rally::Motion", ptr %0, i24 0, i32 9
  %12 = load i8, ptr %11, align 1, !tbaa !45, !range !34
  %13 = getelementptr inbounds %"struct.rally::Motion", ptr %0, i24 0, i32 8
  %14 = load i24, ptr %13, align 1, !tbaa !2
  %15 = sext i24 %14 to i32
  %16 = mul i32 %15, 46080
  %17 = sdiv i32 %16, 100
  %18 = getelementptr inbounds %"struct.rally::Motion", ptr %0, i24 0, i32 4
  %19 = load i32, ptr %18, align 1, !tbaa !60
  %20 = tail call i32 @llvm.abs.i32(i32 %19, i1 true)
  %21 = icmp ugt i32 %20, 24064
  br i1 %21, label %22, label %24

22:                                               ; preds = %2
  %23 = sdiv i32 %16, 200
  br label %29

24:                                               ; preds = %2
  %25 = icmp ugt i32 %20, 19968
  br i1 %25, label %26, label %29

26:                                               ; preds = %24
  %27 = mul nsw i32 %17, 115
  %28 = sdiv i32 %27, 100
  br label %29

29:                                               ; preds = %24, %26, %22
  %30 = phi i32 [ %23, %22 ], [ %28, %26 ], [ %17, %24 ]
  %31 = icmp eq i8 %12, 0
  %32 = sext i16 %4 to i24
  %33 = sext i16 %6 to i24
  %34 = sub nsw i24 %32, %33
  %35 = sext i24 %34 to i32
  %36 = shl i32 %8, 9
  %37 = mul i32 %36, %35
  %38 = sdiv i32 %37, 63
  %39 = sub nsw i32 %38, %10
  %40 = mul nsw i32 %39, 100
  %41 = sdiv i32 %40, 12
  %42 = select i1 %31, i32 0, i32 %1
  %43 = add nsw i32 %41, %42
  %44 = tail call i32 @llvm.smin.i32(i32 %43, i32 %30)
  %45 = sub nsw i32 0, %30
  %46 = tail call i32 @llvm.smax.i32(i32 %44, i32 %45)
  %47 = sub nsw i32 %46, %1
  %48 = sdiv i32 %47, 100
  %49 = add nsw i32 %48, %10
  %50 = icmp eq i32 %8, 0
  %51 = select i1 %50, i32 0, i32 %49
  store i32 %51, ptr %9, align 1
  ret void
}

; Function Attrs: minsize mustprogress nounwind optsize
define linkonce_odr dso_local void @_ZN5rally4game5Rules9raceReadyEv(ptr noundef nonnull align 1 dereferenceable(65) %0) local_unnamed_addr #4 align 2 {
  %2 = getelementptr inbounds %"struct.rally::game::Rules", ptr %0, i24 0, i32 11
  store i32 0, ptr %2, align 1, !tbaa !52
  %3 = getelementptr inbounds %"struct.rally::game::Rules", ptr %0, i24 0, i32 4
  store i32 0, ptr %3, align 1, !tbaa !59
  %4 = getelementptr inbounds %"struct.rally::game::Rules", ptr %0, i24 0, i32 6
  store i32 0, ptr %4, align 1, !tbaa !105
  %5 = getelementptr inbounds %"struct.rally::game::Rules", ptr %0, i24 0, i32 16
  store i8 0, ptr %5, align 1, !tbaa !107
  %6 = getelementptr inbounds %"struct.rally::game::Rules", ptr %0, i24 0, i32 13
  store i32 0, ptr %6, align 1, !tbaa !181
  %7 = getelementptr inbounds %"struct.rally::game::Rules", ptr %0, i24 0, i32 15
  store i16 0, ptr %7, align 1, !tbaa !109
  %8 = getelementptr inbounds %"struct.rally::game::Settings", ptr %0, i24 0, i32 2
  %9 = load i16, ptr %8, align 1, !tbaa !204
  %10 = zext i16 %9 to i32
  %11 = mul nuw nsw i32 %10, 120
  %12 = getelementptr inbounds %"struct.rally::game::Rules", ptr %0, i24 0, i32 5
  store i32 %11, ptr %12, align 1, !tbaa !104
  %13 = getelementptr inbounds %"struct.rally::game::Rules", ptr %0, i24 0, i32 17
  %14 = load i8, ptr %13, align 1, !tbaa !98
  %15 = getelementptr inbounds %"struct.rally::game::Rules", ptr %0, i24 0, i32 18
  store i8 %14, ptr %15, align 1, !tbaa !66
  %16 = getelementptr inbounds %"struct.rally::game::Rules", ptr %0, i24 0, i32 2
  store i8 5, ptr %16, align 1, !tbaa !36
  %17 = getelementptr inbounds %"struct.rally::game::Rules", ptr %0, i24 0, i32 3
  store i32 0, ptr %17, align 1, !tbaa !37
  %18 = getelementptr inbounds %"struct.rally::game::Rules", ptr %0, i24 0, i32 14
  %19 = load i16, ptr %18, align 1, !tbaa !38
  %20 = add i16 %19, 1
  store i16 %20, ptr %18, align 1, !tbaa !38
  ret void
}

; Function Attrs: minsize mustprogress nounwind optsize
define linkonce_odr dso_local noundef i8 @_ZNK5rally4game5Rules14qualifyingGridEm(ptr noundef nonnull align 1 dereferenceable(65) %0, i32 noundef %1) local_unnamed_addr #4 align 2 {
  %3 = getelementptr inbounds %"struct.rally::game::Settings", ptr %0, i24 0, i32 1
  %4 = load i16, ptr %3, align 1, !tbaa !205
  %5 = zext i16 %4 to i32
  %6 = mul nuw nsw i32 %5, 120
  %7 = icmp ult i32 %6, %1
  br i1 %7, label %8, label %20

8:                                                ; preds = %2
  %9 = load i16, ptr %0, align 1, !tbaa !182
  %10 = zext i16 %9 to i32
  %11 = mul nuw nsw i32 %10, 120
  %12 = sub i32 %1, %6
  %13 = mul i32 %12, 6
  %14 = sub nsw i32 %11, %6
  %15 = add i32 %13, -1
  %16 = add i32 %15, %14
  %17 = udiv i32 %16, %14
  %18 = trunc i32 %17 to i8
  %19 = add i8 %18, 1
  br label %20

20:                                               ; preds = %2, %8
  %21 = phi i8 [ %19, %8 ], [ 1, %2 ]
  ret i8 %21
}

; Function Attrs: minsize optsize
declare dso_local void @vdp_adv_use_affine_matrix(i8 noundef, i16 noundef) local_unnamed_addr #2

; Function Attrs: inlinehint minsize mustprogress nounwind optsize
define linkonce_odr dso_local void @_ZN5rally4game11skyViewportERNS_6StreamEiiii(ptr noundef nonnull align 1 dereferenceable(4100) %0, i24 noundef %1, i24 noundef %2, i24 noundef %3, i24 noundef %4) local_unnamed_addr #3 {
  %6 = tail call i24 @llvm.smax.i24(i24 %2, i24 24)
  tail call void @_ZN5rally4game8viewportERNS_6StreamEiiii(ptr noundef nonnull align 1 dereferenceable(4100) %0, i24 noundef %1, i24 noundef %6, i24 noundef %3, i24 noundef %4) #18
  ret void
}

; Function Attrs: minsize optsize
declare dso_local void @vdp_scroll_screen_extent(i24 noundef, i24 noundef, i24 noundef) local_unnamed_addr #2

; Function Attrs: minsize optsize
declare dso_local void @vdp_draw_bitmap(i24 noundef, i24 noundef) local_unnamed_addr #2

; Function Attrs: minsize mustprogress nounwind optsize
define linkonce_odr dso_local noundef i24 @_ZNK5rally10DirectRoad8centerAtEi(ptr noundef nonnull align 1 dereferenceable(2191) %0, i24 noundef %1) local_unnamed_addr #4 align 2 {
  %3 = alloca %"struct.rally::Sample", align 1
  %4 = add i24 %1, -104
  %5 = icmp ult i24 %4, 121
  br i1 %5, label %6, label %11

6:                                                ; preds = %2
  %7 = getelementptr inbounds %"struct.rally::Road", ptr %0, i24 0, i32 5, i24 %1
  %8 = load i32, ptr %7, align 1, !tbaa !46
  %9 = sdiv i32 %8, 256
  %10 = trunc i32 %9 to i24
  br label %46

11:                                               ; preds = %2
  %12 = icmp slt i24 %1, 97
  br i1 %12, label %46, label %13

13:                                               ; preds = %11
  %14 = add nsw i24 %1, -96
  %15 = zext i24 %14 to i32
  %16 = udiv i32 2048000, %15
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %3) #19
  %17 = getelementptr inbounds %"struct.rally::DirectRoad", ptr %0, i24 0, i32 1
  %18 = load i32, ptr %17, align 1, !tbaa !206
  %19 = add nsw i32 %18, %16
  %20 = load ptr, ptr %0, align 1, !tbaa !110
  call void @_ZN5rally11trackSampleElRKNS_8TrackDefE(ptr nonnull sret(%"struct.rally::Sample") align 1 %3, i32 noundef %19, ptr noundef nonnull align 1 dereferenceable(13) %20) #18
  %21 = load i32, ptr %3, align 1, !tbaa !187
  %22 = getelementptr inbounds %"struct.rally::DirectRoad", ptr %0, i24 0, i32 3
  %23 = load i32, ptr %22, align 1, !tbaa !208
  %24 = sub i32 %23, %21
  %25 = getelementptr inbounds %"struct.rally::Sample", ptr %3, i24 0, i32 1
  %26 = load i32, ptr %25, align 1, !tbaa !189
  %27 = getelementptr inbounds %"struct.rally::DirectRoad", ptr %0, i24 0, i32 3, i32 1
  %28 = load i32, ptr %27, align 1, !tbaa !209
  %29 = sub nsw i32 %26, %28
  %30 = getelementptr inbounds %"struct.rally::DirectRoad", ptr %0, i24 0, i32 3, i32 3
  %31 = load i32, ptr %30, align 1, !tbaa !210
  %32 = mul nsw i32 %31, %24
  %33 = getelementptr inbounds %"struct.rally::DirectRoad", ptr %0, i24 0, i32 3, i32 2
  %34 = load i32, ptr %33, align 1, !tbaa !211
  %35 = mul nsw i32 %34, %29
  %36 = add nsw i32 %35, %32
  %37 = sdiv i32 %36, 4096
  %38 = getelementptr inbounds %"struct.rally::DirectRoad", ptr %0, i24 0, i32 2
  %39 = load i32, ptr %38, align 1, !tbaa !212
  %40 = sub nsw i32 %37, %39
  %41 = mul nsw i32 %40, %15
  %42 = sdiv i32 %41, 50
  %43 = add nsw i32 %42, 40960
  %44 = sdiv i32 %43, 256
  %45 = trunc i32 %44 to i24
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %3) #19
  br label %46

46:                                               ; preds = %13, %11, %6
  %47 = phi i24 [ %10, %6 ], [ %45, %13 ], [ 160, %11 ]
  ret i24 %47
}

; Function Attrs: minsize mustprogress nounwind optsize
define linkonce_odr dso_local void @_ZN5rally6Stream4rectEiiiii(ptr noundef nonnull align 1 dereferenceable(4100) %0, i24 noundef %1, i24 noundef %2, i24 noundef %3, i24 noundef %4, i24 noundef %5) local_unnamed_addr #4 align 2 {
  tail call void @_ZN5rally6Stream5colorEi(ptr noundef nonnull align 1 dereferenceable(4100) %0, i24 noundef %5) #18
  tail call void @_ZN5rally6Stream4plotEiii(ptr noundef nonnull align 1 dereferenceable(4100) %0, i24 noundef 4, i24 noundef %1, i24 noundef %2) #18
  tail call void @_ZN5rally6Stream4plotEiii(ptr noundef nonnull align 1 dereferenceable(4100) %0, i24 noundef 101, i24 noundef %3, i24 noundef %4) #18
  ret void
}

; Function Attrs: minsize mustprogress nounwind optsize
define linkonce_odr dso_local void @_ZN5rally6Stream5colorEi(ptr noundef nonnull align 1 dereferenceable(4100) %0, i24 noundef %1) local_unnamed_addr #4 align 2 {
  %3 = getelementptr inbounds %"struct.rally::Stream", ptr %0, i24 0, i32 1
  %4 = load i24, ptr %3, align 1, !tbaa !24
  %5 = icmp ult i24 %4, 4096
  br i1 %5, label %6, label %20

6:                                                ; preds = %2
  %7 = add nuw nsw i24 %4, 1
  store i24 %7, ptr %3, align 1, !tbaa !24
  %8 = getelementptr inbounds [4096 x i8], ptr %0, i24 0, i24 %4
  store i8 18, ptr %8, align 1, !tbaa !22
  %9 = load i24, ptr %3, align 1, !tbaa !24
  %10 = icmp ult i24 %9, 4096
  br i1 %10, label %11, label %20

11:                                               ; preds = %6
  %12 = add nuw nsw i24 %9, 1
  store i24 %12, ptr %3, align 1, !tbaa !24
  %13 = getelementptr inbounds [4096 x i8], ptr %0, i24 0, i24 %9
  store i8 0, ptr %13, align 1, !tbaa !22
  %14 = load i24, ptr %3, align 1, !tbaa !24
  %15 = icmp ult i24 %14, 4096
  br i1 %15, label %16, label %20

16:                                               ; preds = %11
  %17 = trunc i24 %1 to i8
  %18 = add nuw nsw i24 %14, 1
  store i24 %18, ptr %3, align 1, !tbaa !24
  %19 = getelementptr inbounds [4096 x i8], ptr %0, i24 0, i24 %14
  store i8 %17, ptr %19, align 1, !tbaa !22
  br label %22

20:                                               ; preds = %6, %2, %11
  %21 = getelementptr inbounds %"struct.rally::Stream", ptr %0, i24 0, i32 2
  store i8 1, ptr %21, align 1, !tbaa !26
  br label %22

22:                                               ; preds = %16, %20
  ret void
}

; Function Attrs: minsize mustprogress nounwind optsize
define linkonce_odr dso_local void @_ZN5rally6Stream4plotEiii(ptr noundef nonnull align 1 dereferenceable(4100) %0, i24 noundef %1, i24 noundef %2, i24 noundef %3) local_unnamed_addr #4 align 2 {
  %5 = getelementptr inbounds %"struct.rally::Stream", ptr %0, i24 0, i32 1
  %6 = load i24, ptr %5, align 1, !tbaa !24
  %7 = icmp ult i24 %6, 4096
  br i1 %7, label %8, label %17

8:                                                ; preds = %4
  %9 = add nuw nsw i24 %6, 1
  store i24 %9, ptr %5, align 1, !tbaa !24
  %10 = getelementptr inbounds [4096 x i8], ptr %0, i24 0, i24 %6
  store i8 25, ptr %10, align 1, !tbaa !22
  %11 = load i24, ptr %5, align 1, !tbaa !24
  %12 = icmp ult i24 %11, 4096
  br i1 %12, label %13, label %17

13:                                               ; preds = %8
  %14 = trunc i24 %1 to i8
  %15 = add nuw nsw i24 %11, 1
  store i24 %15, ptr %5, align 1, !tbaa !24
  %16 = getelementptr inbounds [4096 x i8], ptr %0, i24 0, i24 %11
  store i8 %14, ptr %16, align 1, !tbaa !22
  br label %19

17:                                               ; preds = %4, %8
  %18 = getelementptr inbounds %"struct.rally::Stream", ptr %0, i24 0, i32 2
  store i8 1, ptr %18, align 1, !tbaa !26
  br label %19

19:                                               ; preds = %13, %17
  tail call void @_ZN5rally6Stream4wordEi(ptr noundef nonnull align 1 dereferenceable(4100) %0, i24 noundef %2) #18
  tail call void @_ZN5rally6Stream4wordEi(ptr noundef nonnull align 1 dereferenceable(4100) %0, i24 noundef %3) #18
  ret void
}

; Function Attrs: minsize mustprogress nounwind optsize
define internal fastcc void @_ZN12_GLOBAL__N_113trafficMatrixEjiii(i24 noundef %0, i24 noundef %1, i24 noundef %2, i24 noundef %3) unnamed_addr #4 {
  %5 = load i24, ptr getelementptr inbounds (%"struct.rally::Stream", ptr @_ZN12_GLOBAL__N_16streamE, i24 0, i32 1), align 1, !tbaa !24
  %6 = icmp ult i24 %5, 4096
  br i1 %6, label %7, label %20

7:                                                ; preds = %4
  %8 = add nuw nsw i24 %5, 1
  store i24 %8, ptr getelementptr inbounds (%"struct.rally::Stream", ptr @_ZN12_GLOBAL__N_16streamE, i24 0, i32 1), align 1, !tbaa !24
  %9 = getelementptr inbounds [4096 x i8], ptr @_ZN12_GLOBAL__N_16streamE, i24 0, i24 %5
  store i8 23, ptr %9, align 1, !tbaa !22
  %10 = load i24, ptr getelementptr inbounds (%"struct.rally::Stream", ptr @_ZN12_GLOBAL__N_16streamE, i24 0, i32 1), align 1, !tbaa !24
  %11 = icmp ult i24 %10, 4096
  br i1 %11, label %12, label %20

12:                                               ; preds = %7
  %13 = add nuw nsw i24 %10, 1
  store i24 %13, ptr getelementptr inbounds (%"struct.rally::Stream", ptr @_ZN12_GLOBAL__N_16streamE, i24 0, i32 1), align 1, !tbaa !24
  %14 = getelementptr inbounds [4096 x i8], ptr @_ZN12_GLOBAL__N_16streamE, i24 0, i24 %10
  store i8 0, ptr %14, align 1, !tbaa !22
  %15 = load i24, ptr getelementptr inbounds (%"struct.rally::Stream", ptr @_ZN12_GLOBAL__N_16streamE, i24 0, i32 1), align 1, !tbaa !24
  %16 = icmp ult i24 %15, 4096
  br i1 %16, label %17, label %20

17:                                               ; preds = %12
  %18 = add nuw nsw i24 %15, 1
  store i24 %18, ptr getelementptr inbounds (%"struct.rally::Stream", ptr @_ZN12_GLOBAL__N_16streamE, i24 0, i32 1), align 1, !tbaa !24
  %19 = getelementptr inbounds [4096 x i8], ptr @_ZN12_GLOBAL__N_16streamE, i24 0, i24 %15
  store i8 -96, ptr %19, align 1, !tbaa !22
  br label %21

20:                                               ; preds = %7, %4, %12
  store i8 1, ptr getelementptr inbounds (%"struct.rally::Stream", ptr @_ZN12_GLOBAL__N_16streamE, i24 0, i32 2), align 1, !tbaa !26
  br label %21

21:                                               ; preds = %17, %20
  tail call void @_ZN5rally6Stream4wordEi(ptr noundef nonnull align 1 dereferenceable(4100) @_ZN12_GLOBAL__N_16streamE, i24 noundef %0) #18
  %22 = load i24, ptr getelementptr inbounds (%"struct.rally::Stream", ptr @_ZN12_GLOBAL__N_16streamE, i24 0, i32 1), align 1, !tbaa !24
  %23 = icmp ult i24 %22, 4096
  br i1 %23, label %24, label %34

24:                                               ; preds = %21
  %25 = add nuw nsw i24 %22, 1
  store i24 %25, ptr getelementptr inbounds (%"struct.rally::Stream", ptr @_ZN12_GLOBAL__N_16streamE, i24 0, i32 1), align 1, !tbaa !24
  %26 = getelementptr inbounds [4096 x i8], ptr @_ZN12_GLOBAL__N_16streamE, i24 0, i24 %22
  store i8 32, ptr %26, align 1, !tbaa !22
  %27 = load i24, ptr getelementptr inbounds (%"struct.rally::Stream", ptr @_ZN12_GLOBAL__N_16streamE, i24 0, i32 1), align 1, !tbaa !24
  %28 = icmp ult i24 %27, 4096
  br i1 %28, label %29, label %34

29:                                               ; preds = %24
  %30 = add nuw nsw i24 %27, 1
  store i24 %30, ptr getelementptr inbounds (%"struct.rally::Stream", ptr @_ZN12_GLOBAL__N_16streamE, i24 0, i32 1), align 1, !tbaa !24
  %31 = getelementptr inbounds [4096 x i8], ptr @_ZN12_GLOBAL__N_16streamE, i24 0, i24 %27
  store i8 0, ptr %31, align 1, !tbaa !22
  %32 = load i24, ptr getelementptr inbounds (%"struct.rally::Stream", ptr @_ZN12_GLOBAL__N_16streamE, i24 0, i32 1), align 1, !tbaa !24
  %33 = icmp ult i24 %32, 4096
  br i1 %33, label %35, label %34

34:                                               ; preds = %24, %21, %29
  store i8 1, ptr getelementptr inbounds (%"struct.rally::Stream", ptr @_ZN12_GLOBAL__N_16streamE, i24 0, i32 2), align 1, !tbaa !26
  br label %48

35:                                               ; preds = %29
  %36 = add nuw nsw i24 %32, 1
  store i24 %36, ptr getelementptr inbounds (%"struct.rally::Stream", ptr @_ZN12_GLOBAL__N_16streamE, i24 0, i32 1), align 1, !tbaa !24
  %37 = getelementptr inbounds [4096 x i8], ptr @_ZN12_GLOBAL__N_16streamE, i24 0, i24 %32
  store i8 23, ptr %37, align 1, !tbaa !22
  %38 = load i24, ptr getelementptr inbounds (%"struct.rally::Stream", ptr @_ZN12_GLOBAL__N_16streamE, i24 0, i32 1), align 1, !tbaa !24
  %39 = icmp ult i24 %38, 4096
  br i1 %39, label %40, label %48

40:                                               ; preds = %35
  %41 = add nuw nsw i24 %38, 1
  store i24 %41, ptr getelementptr inbounds (%"struct.rally::Stream", ptr @_ZN12_GLOBAL__N_16streamE, i24 0, i32 1), align 1, !tbaa !24
  %42 = getelementptr inbounds [4096 x i8], ptr @_ZN12_GLOBAL__N_16streamE, i24 0, i24 %38
  store i8 0, ptr %42, align 1, !tbaa !22
  %43 = load i24, ptr getelementptr inbounds (%"struct.rally::Stream", ptr @_ZN12_GLOBAL__N_16streamE, i24 0, i32 1), align 1, !tbaa !24
  %44 = icmp ult i24 %43, 4096
  br i1 %44, label %45, label %48

45:                                               ; preds = %40
  %46 = add nuw nsw i24 %43, 1
  store i24 %46, ptr getelementptr inbounds (%"struct.rally::Stream", ptr @_ZN12_GLOBAL__N_16streamE, i24 0, i32 1), align 1, !tbaa !24
  %47 = getelementptr inbounds [4096 x i8], ptr @_ZN12_GLOBAL__N_16streamE, i24 0, i24 %43
  store i8 -96, ptr %47, align 1, !tbaa !22
  br label %49

48:                                               ; preds = %34, %35, %40
  store i8 1, ptr getelementptr inbounds (%"struct.rally::Stream", ptr @_ZN12_GLOBAL__N_16streamE, i24 0, i32 2), align 1, !tbaa !26
  br label %49

49:                                               ; preds = %45, %48
  tail call void @_ZN5rally6Stream4wordEi(ptr noundef nonnull align 1 dereferenceable(4100) @_ZN12_GLOBAL__N_16streamE, i24 noundef %0) #18
  %50 = load i24, ptr getelementptr inbounds (%"struct.rally::Stream", ptr @_ZN12_GLOBAL__N_16streamE, i24 0, i32 1), align 1, !tbaa !24
  %51 = icmp ult i24 %50, 4096
  br i1 %51, label %52, label %65

52:                                               ; preds = %49
  %53 = add nuw nsw i24 %50, 1
  store i24 %53, ptr getelementptr inbounds (%"struct.rally::Stream", ptr @_ZN12_GLOBAL__N_16streamE, i24 0, i32 1), align 1, !tbaa !24
  %54 = getelementptr inbounds [4096 x i8], ptr @_ZN12_GLOBAL__N_16streamE, i24 0, i24 %50
  store i8 32, ptr %54, align 1, !tbaa !22
  %55 = load i24, ptr getelementptr inbounds (%"struct.rally::Stream", ptr @_ZN12_GLOBAL__N_16streamE, i24 0, i32 1), align 1, !tbaa !24
  %56 = icmp ult i24 %55, 4096
  br i1 %56, label %57, label %65

57:                                               ; preds = %52
  %58 = add nuw nsw i24 %55, 1
  store i24 %58, ptr getelementptr inbounds (%"struct.rally::Stream", ptr @_ZN12_GLOBAL__N_16streamE, i24 0, i32 1), align 1, !tbaa !24
  %59 = getelementptr inbounds [4096 x i8], ptr @_ZN12_GLOBAL__N_16streamE, i24 0, i24 %55
  store i8 11, ptr %59, align 1, !tbaa !22
  %60 = load i24, ptr getelementptr inbounds (%"struct.rally::Stream", ptr @_ZN12_GLOBAL__N_16streamE, i24 0, i32 1), align 1, !tbaa !24
  %61 = icmp ult i24 %60, 4096
  br i1 %61, label %62, label %65

62:                                               ; preds = %57
  %63 = add nuw nsw i24 %60, 1
  store i24 %63, ptr getelementptr inbounds (%"struct.rally::Stream", ptr @_ZN12_GLOBAL__N_16streamE, i24 0, i32 1), align 1, !tbaa !24
  %64 = getelementptr inbounds [4096 x i8], ptr @_ZN12_GLOBAL__N_16streamE, i24 0, i24 %60
  store i8 -56, ptr %64, align 1, !tbaa !22
  br label %66

65:                                               ; preds = %52, %49, %57
  store i8 1, ptr getelementptr inbounds (%"struct.rally::Stream", ptr @_ZN12_GLOBAL__N_16streamE, i24 0, i32 2), align 1, !tbaa !26
  br label %66

66:                                               ; preds = %62, %65
  tail call void @_ZN5rally6Stream4wordEi(ptr noundef nonnull align 1 dereferenceable(4100) @_ZN12_GLOBAL__N_16streamE, i24 noundef %1) #18
  tail call void @_ZN5rally6Stream4wordEi(ptr noundef nonnull align 1 dereferenceable(4100) @_ZN12_GLOBAL__N_16streamE, i24 noundef 0) #18
  tail call void @_ZN5rally6Stream4wordEi(ptr noundef nonnull align 1 dereferenceable(4100) @_ZN12_GLOBAL__N_16streamE, i24 noundef %3) #18
  tail call void @_ZN5rally6Stream4wordEi(ptr noundef nonnull align 1 dereferenceable(4100) @_ZN12_GLOBAL__N_16streamE, i24 noundef 0) #18
  tail call void @_ZN5rally6Stream4wordEi(ptr noundef nonnull align 1 dereferenceable(4100) @_ZN12_GLOBAL__N_16streamE, i24 noundef %2) #18
  tail call void @_ZN5rally6Stream4wordEi(ptr noundef nonnull align 1 dereferenceable(4100) @_ZN12_GLOBAL__N_16streamE, i24 noundef 0) #18
  tail call fastcc void @_ZN12_GLOBAL__N_15flushEv() #18
  ret void
}

; Function Attrs: minsize optsize
declare dso_local i24 @snprintf(ptr noundef, i24 noundef, ptr noundef, ...) local_unnamed_addr #2

; Function Attrs: argmemonly minsize mustprogress nofree nounwind optsize willreturn
declare dso_local ptr @strcpy(ptr noalias noundef returned writeonly, ptr noalias nocapture noundef readonly) local_unnamed_addr #11

; Function Attrs: minsize mustprogress nounwind optsize
define internal fastcc void @_ZN12_GLOBAL__N_14textEiiPKcii(i24 noundef %0, i24 noundef %1, ptr noundef %2, i24 noundef %3, i24 noundef %4) unnamed_addr #4 {
  tail call void @vdp_set_text_colour(i24 noundef %3) #17
  tail call void @vdp_set_text_bg_colour(i24 noundef %4) #17
  tail call void @vdp_cursor_tab(i24 noundef %0, i24 noundef %1) #17
  %6 = tail call i24 @strlen(ptr noundef nonnull dereferenceable(1) %2) #18
  tail call void @_ZN12_GLOBAL__N_14sendEPKhj(ptr noundef %2, i24 noundef %6) #18
  ret void
}

; Function Attrs: minsize mustprogress nounwind optsize
define internal fastcc void @_ZN12_GLOBAL__N_16centreEiPKci(i24 noundef %0, ptr noundef %1, i24 noundef %2) unnamed_addr #4 {
  %4 = tail call i24 @strlen(ptr noundef nonnull dereferenceable(1) %1) #18
  %5 = sub nsw i24 40, %4
  %6 = sdiv i24 %5, 2
  tail call fastcc void @_ZN12_GLOBAL__N_14textEiiPKcii(i24 noundef %6, i24 noundef %0, ptr noundef %1, i24 noundef %2, i24 noundef 20) #18
  ret void
}

; Function Attrs: minsize mustprogress nounwind optsize
define internal fastcc void @_ZN12_GLOBAL__N_19clockTextEPcjm(ptr noundef %0, i32 noundef %1) unnamed_addr #4 {
  %3 = mul i32 %1, 100
  %4 = udiv i32 %3, 120
  %5 = udiv i32 %3, 720000
  %6 = udiv i32 %3, 12000
  %7 = urem i32 %6, 60
  %8 = urem i32 %4, 100
  %9 = tail call i24 (ptr, i24, ptr, ...) @snprintf(ptr noundef %0, i24 noundef 20, ptr noundef nonnull @.str.45, i32 noundef %5, i32 noundef %7, i32 noundef %8) #17
  ret void
}

; Function Attrs: minsize optsize
declare dso_local void @vdp_cursor_tab(i24 noundef, i24 noundef) local_unnamed_addr #2

; Function Attrs: argmemonly minsize mustprogress nofree nounwind optsize readonly willreturn
declare dso_local i24 @strlen(ptr nocapture noundef) local_unnamed_addr #12

; Function Attrs: minsize nounwind optsize
define linkonce_odr dso_local void @_ZN5rally4game8HudImageC2Ev(ptr noundef nonnull align 1 dereferenceable(240) %0) unnamed_addr #0 align 2 {
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 1 dereferenceable(240) %0, i8 0, i64 240, i1 false)
  br label %2

2:                                                ; preds = %6, %1
  %3 = phi i24 [ 0, %1 ], [ %9, %6 ]
  %4 = icmp eq i24 %3, 120
  br i1 %4, label %5, label %6

5:                                                ; preds = %2
  ret void

6:                                                ; preds = %2
  %7 = getelementptr inbounds [120 x i8], ptr %0, i24 0, i24 %3
  store i8 32, ptr %7, align 1, !tbaa !22
  %8 = getelementptr inbounds %"struct.rally::game::HudImage", ptr %0, i24 0, i32 1, i24 %3
  store i8 15, ptr %8, align 1, !tbaa !22
  %9 = add nuw nsw i24 %3, 1
  br label %2, !llvm.loop !213
}

; Function Attrs: minsize mustprogress nounwind optsize
define linkonce_odr dso_local void @_ZN5rally4game8HudImage3putEjjPKch(ptr noundef nonnull align 1 dereferenceable(240) %0, i24 noundef %1, i24 noundef %2, ptr noundef %3, i8 noundef %4) local_unnamed_addr #4 align 2 {
  %6 = icmp ult i24 %2, 3
  %7 = mul nuw nsw i24 %2, 40
  br i1 %6, label %8, label %21

8:                                                ; preds = %5, %15
  %9 = phi ptr [ %19, %15 ], [ %3, %5 ]
  %10 = phi i24 [ %20, %15 ], [ %1, %5 ]
  %11 = load i8, ptr %9, align 1, !tbaa !22
  %12 = icmp ne i8 %11, 0
  %13 = icmp ult i24 %10, 40
  %14 = select i1 %12, i1 %13, i1 false
  br i1 %14, label %15, label %21

15:                                               ; preds = %8
  %16 = add nuw nsw i24 %10, %7
  %17 = getelementptr inbounds [120 x i8], ptr %0, i24 0, i24 %16
  store i8 %11, ptr %17, align 1, !tbaa !22
  %18 = getelementptr inbounds %"struct.rally::game::HudImage", ptr %0, i24 0, i32 1, i24 %16
  store i8 %4, ptr %18, align 1, !tbaa !22
  %19 = getelementptr inbounds i8, ptr %9, i24 1
  %20 = add nuw nsw i24 %10, 1
  br label %8, !llvm.loop !214

21:                                               ; preds = %8, %5
  ret void
}

; Function Attrs: minsize mustprogress nounwind optsize
define linkonce_odr dso_local void @_ZN5rally4game3Hud4emitERNS_6StreamEjRKNS0_8HudImageE(ptr noundef nonnull align 1 dereferenceable(482) %0, ptr noundef nonnull align 1 dereferenceable(4100) %1, i24 noundef %2, ptr noundef nonnull align 1 dereferenceable(240) %3) local_unnamed_addr #4 align 2 {
  %5 = getelementptr inbounds %"struct.rally::game::Hud", ptr %0, i24 0, i32 1, i24 %2
  %6 = load i8, ptr %5, align 1, !tbaa !12, !range !34
  %7 = icmp eq i8 %6, 0
  br i1 %7, label %8, label %9

8:                                                ; preds = %4
  tail call void @_ZN5rally6Stream4rectEiiiii(ptr noundef nonnull align 1 dereferenceable(4100) %1, i24 noundef 0, i24 noundef 0, i24 noundef 319, i24 noundef 23, i24 noundef 20) #18
  br label %9

9:                                                ; preds = %8, %4
  %10 = getelementptr inbounds [2 x %"struct.rally::game::HudImage"], ptr %0, i24 0, i24 %2
  %11 = getelementptr inbounds %"struct.rally::Stream", ptr %1, i24 0, i32 1
  %12 = getelementptr inbounds %"struct.rally::Stream", ptr %1, i24 0, i32 2
  br label %13

13:                                               ; preds = %23, %9
  %14 = phi i24 [ 0, %9 ], [ %24, %23 ]
  %15 = icmp eq i24 %14, 3
  br i1 %15, label %19, label %16

16:                                               ; preds = %13
  %17 = mul nuw nsw i24 %14, 40
  %18 = trunc i24 %14 to i8
  br label %20

19:                                               ; preds = %13
  tail call void @llvm.memcpy.p0.p0.i24(ptr noundef nonnull align 1 dereferenceable(240) %10, ptr noundef nonnull align 1 dereferenceable(240) %3, i24 240, i1 false), !tbaa.struct !215
  store i8 1, ptr %5, align 1, !tbaa !12
  ret void

20:                                               ; preds = %43, %16
  %21 = phi i24 [ 0, %16 ], [ %44, %43 ]
  %22 = icmp ult i24 %21, 40
  br i1 %22, label %25, label %23

23:                                               ; preds = %20
  %24 = add nuw nsw i24 %14, 1
  br label %13, !llvm.loop !216

25:                                               ; preds = %20
  %26 = add i24 %21, %17
  %27 = load i8, ptr %5, align 1, !tbaa !12, !range !34
  %28 = icmp eq i8 %27, 0
  br i1 %28, label %45, label %29

29:                                               ; preds = %25
  %30 = getelementptr inbounds [120 x i8], ptr %10, i24 0, i24 %26
  %31 = load i8, ptr %30, align 1, !tbaa !22
  %32 = getelementptr inbounds [120 x i8], ptr %3, i24 0, i24 %26
  %33 = load i8, ptr %32, align 1, !tbaa !22
  %34 = icmp eq i8 %31, %33
  br i1 %34, label %35, label %45

35:                                               ; preds = %29
  %36 = getelementptr inbounds [2 x %"struct.rally::game::HudImage"], ptr %0, i24 0, i24 %2, i32 1, i24 %26
  %37 = load i8, ptr %36, align 1, !tbaa !22
  %38 = getelementptr inbounds %"struct.rally::game::HudImage", ptr %3, i24 0, i32 1, i24 %26
  %39 = load i8, ptr %38, align 1, !tbaa !22
  %40 = icmp eq i8 %37, %39
  br i1 %40, label %41, label %45

41:                                               ; preds = %35
  %42 = add nuw nsw i24 %21, 1
  br label %43

43:                                               ; preds = %105, %101, %119, %41
  %44 = phi i24 [ %42, %41 ], [ %102, %119 ], [ %89, %101 ], [ %102, %105 ]
  br label %20, !llvm.loop !217

45:                                               ; preds = %35, %29, %25
  %46 = getelementptr inbounds %"struct.rally::game::HudImage", ptr %3, i24 0, i32 1, i24 %26
  %47 = load i8, ptr %46, align 1, !tbaa !22
  %48 = load i24, ptr %11, align 1, !tbaa !24
  %49 = icmp ult i24 %48, 4096
  br i1 %49, label %50, label %60

50:                                               ; preds = %45
  %51 = add nuw nsw i24 %48, 1
  store i24 %51, ptr %11, align 1, !tbaa !24
  %52 = getelementptr inbounds [4096 x i8], ptr %1, i24 0, i24 %48
  store i8 17, ptr %52, align 1, !tbaa !22
  %53 = load i24, ptr %11, align 1, !tbaa !24
  %54 = icmp ult i24 %53, 4096
  br i1 %54, label %55, label %60

55:                                               ; preds = %50
  %56 = add nuw nsw i24 %53, 1
  store i24 %56, ptr %11, align 1, !tbaa !24
  %57 = getelementptr inbounds [4096 x i8], ptr %1, i24 0, i24 %53
  store i8 -108, ptr %57, align 1, !tbaa !22
  %58 = load i24, ptr %11, align 1, !tbaa !24
  %59 = icmp ult i24 %58, 4096
  br i1 %59, label %61, label %60

60:                                               ; preds = %50, %45, %55
  store i8 1, ptr %12, align 1, !tbaa !26
  br label %71

61:                                               ; preds = %55
  %62 = add nuw nsw i24 %58, 1
  store i24 %62, ptr %11, align 1, !tbaa !24
  %63 = getelementptr inbounds [4096 x i8], ptr %1, i24 0, i24 %58
  store i8 17, ptr %63, align 1, !tbaa !22
  %64 = load i24, ptr %11, align 1, !tbaa !24
  %65 = icmp ult i24 %64, 4096
  br i1 %65, label %66, label %71

66:                                               ; preds = %61
  %67 = add nuw nsw i24 %64, 1
  store i24 %67, ptr %11, align 1, !tbaa !24
  %68 = getelementptr inbounds [4096 x i8], ptr %1, i24 0, i24 %64
  store i8 %47, ptr %68, align 1, !tbaa !22
  %69 = load i24, ptr %11, align 1, !tbaa !24
  %70 = icmp ult i24 %69, 4096
  br i1 %70, label %72, label %71

71:                                               ; preds = %60, %61, %66
  store i8 1, ptr %12, align 1, !tbaa !26
  br label %86

72:                                               ; preds = %66
  %73 = add nuw nsw i24 %69, 1
  store i24 %73, ptr %11, align 1, !tbaa !24
  %74 = getelementptr inbounds [4096 x i8], ptr %1, i24 0, i24 %69
  store i8 31, ptr %74, align 1, !tbaa !22
  %75 = load i24, ptr %11, align 1, !tbaa !24
  %76 = icmp ult i24 %75, 4096
  br i1 %76, label %77, label %86

77:                                               ; preds = %72
  %78 = trunc i24 %21 to i8
  %79 = add nuw nsw i24 %75, 1
  store i24 %79, ptr %11, align 1, !tbaa !24
  %80 = getelementptr inbounds [4096 x i8], ptr %1, i24 0, i24 %75
  store i8 %78, ptr %80, align 1, !tbaa !22
  %81 = load i24, ptr %11, align 1, !tbaa !24
  %82 = icmp ult i24 %81, 4096
  br i1 %82, label %83, label %86

83:                                               ; preds = %77
  %84 = add nuw nsw i24 %81, 1
  store i24 %84, ptr %11, align 1, !tbaa !24
  %85 = getelementptr inbounds [4096 x i8], ptr %1, i24 0, i24 %81
  store i8 %18, ptr %85, align 1, !tbaa !22
  br label %87

86:                                               ; preds = %71, %72, %77
  store i8 1, ptr %12, align 1, !tbaa !26
  br label %87

87:                                               ; preds = %83, %86
  %88 = tail call i24 @llvm.umax.i24(i24 %21, i24 39)
  %89 = add nuw i24 %88, 1
  br label %90

90:                                               ; preds = %118, %87
  %91 = phi i24 [ %21, %87 ], [ %102, %118 ]
  %92 = phi i24 [ %26, %87 ], [ %103, %118 ]
  %93 = load i24, ptr %11, align 1, !tbaa !24
  %94 = icmp ult i24 %93, 4096
  br i1 %94, label %95, label %100

95:                                               ; preds = %90
  %96 = getelementptr inbounds [120 x i8], ptr %3, i24 0, i24 %92
  %97 = load i8, ptr %96, align 1, !tbaa !22
  %98 = add nuw nsw i24 %93, 1
  store i24 %98, ptr %11, align 1, !tbaa !24
  %99 = getelementptr inbounds [4096 x i8], ptr %1, i24 0, i24 %93
  store i8 %97, ptr %99, align 1, !tbaa !22
  br label %101

100:                                              ; preds = %90
  store i8 1, ptr %12, align 1, !tbaa !26
  br label %101

101:                                              ; preds = %95, %100
  %102 = add i24 %91, 1
  %103 = add i24 %92, 1
  %104 = icmp ult i24 %102, 40
  br i1 %104, label %105, label %43

105:                                              ; preds = %101
  %106 = getelementptr inbounds %"struct.rally::game::HudImage", ptr %3, i24 0, i32 1, i24 %103
  %107 = load i8, ptr %106, align 1, !tbaa !22
  %108 = icmp eq i8 %107, %47
  br i1 %108, label %109, label %43

109:                                              ; preds = %105
  %110 = load i8, ptr %5, align 1, !tbaa !12, !range !34
  %111 = icmp eq i8 %110, 0
  br i1 %111, label %118, label %112

112:                                              ; preds = %109
  %113 = getelementptr inbounds [120 x i8], ptr %10, i24 0, i24 %103
  %114 = load i8, ptr %113, align 1, !tbaa !22
  %115 = getelementptr inbounds [120 x i8], ptr %3, i24 0, i24 %103
  %116 = load i8, ptr %115, align 1, !tbaa !22
  %117 = icmp eq i8 %114, %116
  br i1 %117, label %119, label %118

118:                                              ; preds = %112, %109, %119
  br label %90, !llvm.loop !218

119:                                              ; preds = %112
  %120 = getelementptr inbounds [2 x %"struct.rally::game::HudImage"], ptr %0, i24 0, i24 %2, i32 1, i24 %103
  %121 = load i8, ptr %120, align 1, !tbaa !22
  %122 = icmp eq i8 %121, %47
  br i1 %122, label %43, label %118
}

; Function Attrs: argmemonly mustprogress nocallback nofree nounwind willreturn writeonly
declare void @llvm.memset.p0.i64(ptr nocapture writeonly, i8, i64, i1 immarg) #13

; Function Attrs: inlinehint minsize nounwind optsize
define linkonce_odr dso_local noundef i1 @_ZN5rally4game12writeRecordsEPKcRKNS0_7RecordsE(ptr noundef %0, ptr noundef nonnull align 1 dereferenceable(2304) %1) local_unnamed_addr #7 {
  %3 = alloca [2320 x i8], align 1
  %4 = alloca %"struct.rally::game::Records", align 1
  call void @llvm.lifetime.start.p0(i64 2320, ptr nonnull %3) #19
  call void @_ZNK5rally4game7Records6encodeEPh(ptr noundef nonnull align 1 dereferenceable(2304) %1, ptr noundef nonnull %3) #18
  %5 = call ptr @fopen(ptr noundef %0, ptr noundef nonnull @.str.59) #18
  %6 = icmp eq ptr %5, null
  br i1 %6, label %35, label %7

7:                                                ; preds = %2
  %8 = call i24 @fwrite(ptr noundef nonnull %3, i24 noundef 1, i24 noundef 2320, ptr noundef nonnull %5) #18
  %9 = icmp eq i24 %8, 2320
  %10 = call i24 @fclose(ptr noundef nonnull %5) #18
  %11 = icmp eq i24 %10, 0
  %12 = and i1 %9, %11
  br i1 %12, label %13, label %35

13:                                               ; preds = %7
  call void @llvm.lifetime.start.p0(i64 2304, ptr nonnull %4) #19
  call void @llvm.memset.p0.i24(ptr noundef nonnull align 1 dereferenceable(2304) %4, i8 0, i24 2304, i1 false), !tbaa !46
  %14 = call noundef i1 @_ZN5rally4game11readRecordsEPKcRNS0_7RecordsE(ptr noundef %0, ptr noundef nonnull align 1 dereferenceable(2304) %4) #18
  br i1 %14, label %15, label %33

15:                                               ; preds = %13, %24
  %16 = phi i24 [ %30, %24 ], [ 0, %13 ]
  %17 = icmp eq i24 %16, 288
  br i1 %17, label %31, label %18

18:                                               ; preds = %15
  %19 = getelementptr inbounds [288 x %"struct.rally::game::Record"], ptr %1, i24 0, i24 %16
  %20 = load i32, ptr %19, align 1, !tbaa !102
  %21 = getelementptr inbounds [288 x %"struct.rally::game::Record"], ptr %4, i24 0, i24 %16
  %22 = load i32, ptr %21, align 1, !tbaa !102
  %23 = icmp eq i32 %20, %22
  br i1 %23, label %24, label %31

24:                                               ; preds = %18
  %25 = getelementptr inbounds [288 x %"struct.rally::game::Record"], ptr %1, i24 0, i24 %16, i32 1
  %26 = load i32, ptr %25, align 1, !tbaa !178
  %27 = getelementptr inbounds [288 x %"struct.rally::game::Record"], ptr %4, i24 0, i24 %16, i32 1
  %28 = load i32, ptr %27, align 1, !tbaa !178
  %29 = icmp eq i32 %26, %28
  %30 = add nuw nsw i24 %16, 1
  br i1 %29, label %15, label %31, !llvm.loop !219

31:                                               ; preds = %18, %24, %15
  %32 = icmp ugt i24 %16, 287
  br label %33

33:                                               ; preds = %31, %13
  %34 = phi i1 [ false, %13 ], [ %32, %31 ]
  call void @llvm.lifetime.end.p0(i64 2304, ptr nonnull %4) #19
  br label %35

35:                                               ; preds = %33, %7, %2
  %36 = phi i1 [ false, %2 ], [ %34, %33 ], [ false, %7 ]
  call void @llvm.lifetime.end.p0(i64 2320, ptr nonnull %3) #19
  ret i1 %36
}

; Function Attrs: minsize nofree nounwind optsize
declare dso_local noundef i24 @remove(ptr nocapture noundef readonly) local_unnamed_addr #9

; Function Attrs: minsize optsize
declare dso_local i8 @mos_ren(ptr noundef, ptr noundef) local_unnamed_addr #2

; Function Attrs: minsize mustprogress nounwind optsize
define linkonce_odr dso_local void @_ZNK5rally4game7Records6encodeEPh(ptr noundef nonnull align 1 dereferenceable(2304) %0, ptr noundef %1) local_unnamed_addr #4 align 2 {
  store i64 3544431090972316225, ptr %1, align 1
  %3 = getelementptr inbounds i8, ptr %1, i24 8
  tail call void @_ZN5rally4game7Records5put32EPhm(ptr noundef nonnull %3, i32 noundef 288) #18
  %4 = getelementptr inbounds i8, ptr %1, i24 16
  %5 = getelementptr inbounds i8, ptr %1, i24 20
  br label %6

6:                                                ; preds = %12, %2
  %7 = phi i24 [ 0, %2 ], [ %20, %12 ]
  %8 = icmp eq i24 %7, 288
  br i1 %8, label %9, label %12

9:                                                ; preds = %6
  %10 = getelementptr inbounds i8, ptr %1, i24 12
  %11 = tail call noundef i32 @_ZN5rally4game7Records4hashEPKhj(ptr noundef nonnull %4, i24 noundef 2304) #18
  tail call void @_ZN5rally4game7Records5put32EPhm(ptr noundef nonnull %10, i32 noundef %11) #18
  ret void

12:                                               ; preds = %6
  %13 = shl nuw nsw i24 %7, 3
  %14 = getelementptr inbounds i8, ptr %4, i24 %13
  %15 = getelementptr inbounds [288 x %"struct.rally::game::Record"], ptr %0, i24 0, i24 %7
  %16 = load i32, ptr %15, align 1, !tbaa !102
  tail call void @_ZN5rally4game7Records5put32EPhm(ptr noundef nonnull %14, i32 noundef %16) #18
  %17 = getelementptr inbounds i8, ptr %5, i24 %13
  %18 = getelementptr inbounds [288 x %"struct.rally::game::Record"], ptr %0, i24 0, i24 %7, i32 1
  %19 = load i32, ptr %18, align 1, !tbaa !178
  tail call void @_ZN5rally4game7Records5put32EPhm(ptr noundef nonnull %17, i32 noundef %19) #18
  %20 = add nuw nsw i24 %7, 1
  br label %6, !llvm.loop !220
}

; Function Attrs: minsize nofree nounwind optsize
declare dso_local noundef i24 @fwrite(ptr nocapture noundef, i24 noundef, i24 noundef, ptr nocapture noundef) local_unnamed_addr #9

; Function Attrs: minsize mustprogress nounwind optsize
define linkonce_odr dso_local void @_ZN5rally4game7Records5put32EPhm(ptr noundef %0, i32 noundef %1) local_unnamed_addr #4 align 2 {
  br label %3

3:                                                ; preds = %8, %2
  %4 = phi i32 [ %1, %2 ], [ %11, %8 ]
  %5 = phi i24 [ 0, %2 ], [ %12, %8 ]
  %6 = icmp eq i24 %5, 4
  br i1 %6, label %7, label %8

7:                                                ; preds = %3
  ret void

8:                                                ; preds = %3
  %9 = trunc i32 %4 to i8
  %10 = getelementptr inbounds i8, ptr %0, i24 %5
  store i8 %9, ptr %10, align 1, !tbaa !22
  %11 = lshr i32 %4, 8
  %12 = add nuw nsw i24 %5, 1
  br label %3, !llvm.loop !221
}

; Function Attrs: minsize mustprogress nounwind optsize
define linkonce_odr dso_local void @_ZN5rally10DirectRoad7projectElll(ptr noundef nonnull align 1 dereferenceable(2191) %0, i32 noundef %1, i32 noundef %2, i32 noundef %3) local_unnamed_addr #4 align 2 {
  %5 = alloca %"struct.rally::Sample", align 1
  %6 = sdiv i32 %1, 100
  %7 = shl nsw i32 %6, 8
  %8 = mul i32 %6, 100
  %9 = sub i32 %1, %8
  %10 = shl nsw i32 %9, 8
  %11 = sdiv i32 %10, 100
  %12 = add nsw i32 %11, %7
  %13 = getelementptr inbounds %"struct.rally::DirectRoad", ptr %0, i24 0, i32 1
  store i32 %12, ptr %13, align 1, !tbaa !206
  %14 = getelementptr inbounds %"struct.rally::DirectRoad", ptr %0, i24 0, i32 2
  store i32 %3, ptr %14, align 1, !tbaa !212
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %5) #19
  %15 = load ptr, ptr %0, align 1, !tbaa !110
  call void @_ZN5rally11trackSampleElRKNS_8TrackDefE(ptr nonnull sret(%"struct.rally::Sample") align 1 %5, i32 noundef %12, ptr noundef nonnull align 1 dereferenceable(13) %15) #18
  %16 = getelementptr inbounds %"struct.rally::DirectRoad", ptr %0, i24 0, i32 3
  call void @llvm.memcpy.p0.p0.i24(ptr noundef nonnull align 1 dereferenceable(16) %16, ptr noundef nonnull align 1 dereferenceable(16) %5, i24 16, i1 false), !tbaa.struct !222
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %5) #19
  call void @_ZN5rally4Road7projectElll(ptr noundef nonnull align 1 dereferenceable(2167) %0, i32 noundef %1, i32 noundef %2, i32 noundef %3) #18
  ret void
}

; Function Attrs: inlinehint minsize mustprogress nounwind optsize
define linkonce_odr dso_local noundef i24 @_ZN5rally14sceneryHeadingEll(i32 noundef %0, i32 noundef %1) local_unnamed_addr #3 {
  %3 = icmp slt i32 %0, 0
  %4 = tail call i32 @llvm.abs.i32(i32 %0, i1 true)
  %5 = icmp slt i32 %1, 0
  %6 = tail call i32 @llvm.abs.i32(i32 %1, i1 true)
  %7 = or i32 %1, %0
  %8 = icmp eq i32 %7, 0
  br i1 %8, label %33, label %9

9:                                                ; preds = %2
  %10 = icmp ult i32 %4, %6
  br i1 %10, label %18, label %11

11:                                               ; preds = %9
  %12 = shl nsw i32 %6, 8
  %13 = udiv i32 %12, %4
  %14 = trunc i32 %13 to i24
  %15 = getelementptr inbounds [257 x i8], ptr @_ZN5rallyL11HeadingAtanE, i24 0, i24 %14
  %16 = load i8, ptr %15, align 1, !tbaa !22
  %17 = zext i8 %16 to i24
  br label %26

18:                                               ; preds = %9
  %19 = shl nsw i32 %4, 8
  %20 = udiv i32 %19, %6
  %21 = trunc i32 %20 to i24
  %22 = getelementptr inbounds [257 x i8], ptr @_ZN5rallyL11HeadingAtanE, i24 0, i24 %21
  %23 = load i8, ptr %22, align 1, !tbaa !22
  %24 = zext i8 %23 to i24
  %25 = sub nuw nsw i24 256, %24
  br label %26

26:                                               ; preds = %18, %11
  %27 = phi i24 [ %17, %11 ], [ %25, %18 ]
  %28 = sub nuw nsw i24 512, %27
  %29 = select i1 %3, i24 %28, i24 %27
  %30 = sub nsw i24 0, %29
  %31 = select i1 %5, i24 %30, i24 %29
  %32 = and i24 %31, 1023
  br label %33

33:                                               ; preds = %2, %26
  %34 = phi i24 [ %32, %26 ], [ 0, %2 ]
  ret i24 %34
}

; Function Attrs: minsize mustprogress nounwind optsize
define linkonce_odr dso_local void @_ZN5rally14SceneryHistory7prepareEi(ptr noalias sret(%"struct.rally::SceneryUpdate") align 1 %0, ptr noundef nonnull align 1 dereferenceable(11) %1, i24 noundef %2) local_unnamed_addr #4 align 2 {
  %4 = and i24 %2, 1023
  %5 = getelementptr inbounds %"struct.rally::SceneryHistory", ptr %1, i24 0, i32 2
  %6 = load i24, ptr %5, align 1, !tbaa !99
  %7 = getelementptr inbounds [2 x i24], ptr %1, i24 0, i24 %6
  %8 = load i24, ptr %7, align 1, !tbaa !92
  %9 = add nuw nsw i24 %4, 1536
  %10 = sub i24 %9, %8
  %11 = srem i24 %10, 1024
  %12 = add nsw i24 %11, -512
  %13 = getelementptr inbounds %"struct.rally::SceneryHistory", ptr %1, i24 0, i32 1, i24 %6
  %14 = load i8, ptr %13, align 1, !tbaa !12, !range !34
  %15 = icmp eq i8 %14, 0
  %16 = icmp sgt i24 %11, 767
  %17 = select i1 %15, i1 true, i1 %16
  %18 = icmp slt i24 %11, 257
  %19 = select i1 %17, i1 true, i1 %18
  store i24 %4, ptr %7, align 1, !tbaa !92
  %20 = load i24, ptr %5, align 1, !tbaa !99
  %21 = getelementptr inbounds %"struct.rally::SceneryHistory", ptr %1, i24 0, i32 1, i24 %20
  store i8 1, ptr %21, align 1, !tbaa !12
  br i1 %19, label %22, label %26

22:                                               ; preds = %3
  store i24 0, ptr %0, align 1, !tbaa !131
  %23 = getelementptr inbounds %"struct.rally::SceneryUpdate", ptr %0, i24 0, i32 1
  store i24 0, ptr %23, align 1, !tbaa !133
  %24 = getelementptr inbounds %"struct.rally::SceneryUpdate", ptr %0, i24 0, i32 2
  store i24 319, ptr %24, align 1, !tbaa !134
  %25 = getelementptr inbounds %"struct.rally::SceneryUpdate", ptr %0, i24 0, i32 3
  store i8 1, ptr %25, align 1, !tbaa !135
  br label %40

26:                                               ; preds = %3
  %27 = icmp eq i24 %12, 0
  br i1 %27, label %28, label %29

28:                                               ; preds = %26
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 1 dereferenceable(10) %0, i8 0, i64 10, i1 false)
  br label %40

29:                                               ; preds = %26
  %30 = icmp ugt i24 %11, 512
  store i24 %12, ptr %0, align 1, !tbaa !131
  %31 = getelementptr inbounds %"struct.rally::SceneryUpdate", ptr %0, i24 0, i32 1
  br i1 %30, label %32, label %36

32:                                               ; preds = %29
  %33 = sub nuw nsw i24 832, %11
  store i24 %33, ptr %31, align 1, !tbaa !133
  %34 = getelementptr inbounds %"struct.rally::SceneryUpdate", ptr %0, i24 0, i32 2
  store i24 319, ptr %34, align 1, !tbaa !134
  %35 = getelementptr inbounds %"struct.rally::SceneryUpdate", ptr %0, i24 0, i32 3
  store i8 1, ptr %35, align 1, !tbaa !135
  br label %40

36:                                               ; preds = %29
  store i24 0, ptr %31, align 1, !tbaa !133
  %37 = getelementptr inbounds %"struct.rally::SceneryUpdate", ptr %0, i24 0, i32 2
  %38 = sub nsw i24 511, %11
  store i24 %38, ptr %37, align 1, !tbaa !134
  %39 = getelementptr inbounds %"struct.rally::SceneryUpdate", ptr %0, i24 0, i32 3
  store i8 1, ptr %39, align 1, !tbaa !135
  br label %40

40:                                               ; preds = %32, %36, %28, %22
  ret void
}

; Function Attrs: inlinehint minsize mustprogress nounwind optsize
define linkonce_odr dso_local noundef i16 @_ZN5rally3r1816headingFromCrossEl(i32 noundef %0) local_unnamed_addr #3 {
  %2 = icmp slt i32 %0, 0
  %3 = tail call i32 @llvm.smin.i32(i32 %0, i32 4096)
  %4 = tail call i32 @llvm.smax.i32(i32 %3, i32 -4096)
  %5 = trunc i32 %4 to i24
  %6 = sub nsw i24 0, %5
  %7 = select i1 %2, i24 %6, i24 %5
  %8 = icmp ult i24 %7, 3585
  br i1 %8, label %9, label %11

9:                                                ; preds = %1
  %10 = lshr i24 %7, 5
  br label %23

11:                                               ; preds = %1
  %12 = icmp ult i24 %7, 3969
  br i1 %12, label %13, label %17

13:                                               ; preds = %11
  %14 = add nsw i24 %7, -3584
  %15 = lshr i24 %14, 3
  %16 = add nuw nsw i24 %15, 112
  br label %23

17:                                               ; preds = %11
  %18 = add nsw i24 %7, -3808
  %19 = getelementptr inbounds [289 x i16], ptr @_ZN5rally3r18L13HeadingAnglesE, i24 0, i24 %18
  %20 = load i16, ptr %19, align 1, !tbaa !57
  %21 = sub i16 0, %20
  %22 = select i1 %2, i16 %21, i16 %20
  br label %46

23:                                               ; preds = %13, %9
  %24 = phi i24 [ 7, %13 ], [ 31, %9 ]
  %25 = phi i24 [ %16, %13 ], [ %10, %9 ]
  %26 = phi i24 [ 3, %13 ], [ 5, %9 ]
  %27 = and i24 %7, %24
  %28 = getelementptr inbounds [289 x i16], ptr @_ZN5rally3r18L13HeadingAnglesE, i24 0, i24 %25
  %29 = load i16, ptr %28, align 1, !tbaa !57
  %30 = sext i16 %29 to i24
  %31 = icmp eq i24 %27, 0
  br i1 %31, label %41, label %32

32:                                               ; preds = %23
  %33 = add nuw nsw i24 %25, 1
  %34 = getelementptr inbounds [289 x i16], ptr @_ZN5rally3r18L13HeadingAnglesE, i24 0, i24 %33
  %35 = load i16, ptr %34, align 1, !tbaa !57
  %36 = sext i16 %35 to i24
  %37 = sub nsw i24 %36, %30
  %38 = mul nsw i24 %37, %27
  %39 = ashr i24 %38, %26
  %40 = add nsw i24 %39, %30
  br label %41

41:                                               ; preds = %32, %23
  %42 = phi i24 [ %40, %32 ], [ %30, %23 ]
  %43 = sub nsw i24 0, %42
  %44 = select i1 %2, i24 %43, i24 %42
  %45 = trunc i24 %44 to i16
  br label %46

46:                                               ; preds = %17, %41
  %47 = phi i16 [ %45, %41 ], [ %22, %17 ]
  ret i16 %47
}

; Function Attrs: inlinehint minsize mustprogress nounwind optsize
define linkonce_odr dso_local noundef i16 @_ZN5rally3r1814viewingBearingEi(i24 noundef %0) local_unnamed_addr #3 {
  %2 = add nsw i24 %0, -160
  %3 = icmp slt i24 %0, 160
  %4 = sub i24 160, %0
  %5 = select i1 %3, i24 %4, i24 %2
  %6 = tail call i24 @llvm.umin.i24(i24 %5, i24 512)
  %7 = lshr i24 %6, 1
  %8 = getelementptr inbounds [257 x i16], ptr @_ZN5rally3r18L13BearingAnglesE, i24 0, i24 %7
  %9 = load i16, ptr %8, align 1, !tbaa !57
  %10 = sext i16 %9 to i24
  %11 = and i24 %6, 1
  %12 = icmp eq i24 %11, 0
  br i1 %12, label %22, label %13

13:                                               ; preds = %1
  %14 = add nuw nsw i24 %7, 1
  %15 = getelementptr inbounds [257 x i16], ptr @_ZN5rally3r18L13BearingAnglesE, i24 0, i24 %14
  %16 = load i16, ptr %15, align 1, !tbaa !57
  %17 = sext i16 %16 to i24
  %18 = sub nsw i24 1, %10
  %19 = add nsw i24 %18, %17
  %20 = sdiv i24 %19, 2
  %21 = add nsw i24 %20, %10
  br label %22

22:                                               ; preds = %13, %1
  %23 = phi i24 [ %21, %13 ], [ %10, %1 ]
  %24 = sub nsw i24 0, %23
  %25 = select i1 %3, i24 %24, i24 %23
  %26 = trunc i24 %25 to i16
  ret i16 %26
}

; Function Attrs: inlinehint minsize mustprogress nounwind optsize
define linkonce_odr dso_local void @_ZN5rally3r1810playerPoseEiib(ptr noalias sret(%"struct.rally::r18::Pose") align 1 %0, i24 noundef %1, i24 noundef %2, i1 noundef %3) local_unnamed_addr #3 {
  br i1 %3, label %10, label %5

5:                                                ; preds = %4
  %6 = tail call i24 @llvm.abs.i24(i24 %1, i1 true)
  %7 = shl i24 %6, 2
  %8 = add i24 %7, 10
  %9 = udiv i24 %8, 21
  br label %18

10:                                               ; preds = %4
  %11 = shl nsw i24 %1, 8
  %12 = tail call noundef i16 @_ZN5rally3r1814viewingBearingEi(i24 noundef %2) #18
  %13 = sext i16 %12 to i24
  %14 = sub nsw i24 %11, %13
  %15 = tail call i24 @llvm.abs.i24(i24 %14, i1 true)
  %16 = add nuw i24 %15, 672
  %17 = udiv i24 %16, 1344
  br label %18

18:                                               ; preds = %10, %5
  %19 = phi i24 [ %17, %10 ], [ %9, %5 ]
  %20 = phi i24 [ %14, %10 ], [ %1, %5 ]
  %21 = tail call i24 @llvm.umin.i24(i24 %19, i24 4)
  %22 = trunc i24 %21 to i8
  store i8 %22, ptr %0, align 1, !tbaa !141
  %23 = icmp sgt i24 %20, 0
  %24 = zext i1 %23 to i8
  %25 = getelementptr inbounds %"struct.rally::r18::Pose", ptr %0, i24 0, i32 1
  store i8 %24, ptr %25, align 1
  ret void
}

; Function Attrs: minsize mustprogress nounwind optsize
define linkonce_odr dso_local void @_ZN5rally4Road7projectElll(ptr noundef nonnull align 1 dereferenceable(2167) %0, i32 noundef %1, i32 noundef %2, i32 noundef %3) local_unnamed_addr #4 align 2 {
  %5 = alloca %"struct.rally::Sample", align 1
  %6 = alloca %"struct.rally::Sample", align 1
  %7 = getelementptr inbounds %"struct.rally::Road", ptr %0, i24 0, i32 1
  %8 = load i8, ptr %7, align 1, !tbaa !223, !range !34
  %9 = icmp eq i8 %8, 0
  br i1 %9, label %10, label %12

10:                                               ; preds = %4
  %11 = load ptr, ptr %0, align 1, !tbaa !110
  br label %24

12:                                               ; preds = %4
  %13 = sdiv i32 %1, 1600
  %14 = trunc i32 %13 to i24
  %15 = load ptr, ptr %0, align 1, !tbaa !110
  %16 = icmp eq ptr %15, @_ZN5rallyL4FujiE
  %17 = add nsw i24 %14, 360
  %18 = select i1 %16, i24 %17, i24 %14
  %19 = getelementptr inbounds [2408 x i16], ptr @_ZN5rallyL11BandOffsetsE, i24 0, i24 %18
  %20 = load i16, ptr %19, align 1, !tbaa !57
  %21 = zext i16 %20 to i24
  %22 = getelementptr inbounds i8, ptr @_ZN5rallyL8BandEndsE, i24 %21
  %23 = getelementptr inbounds %"struct.rally::Road", ptr %0, i24 0, i32 2
  store ptr %22, ptr %23, align 1, !tbaa !224
  br label %24

24:                                               ; preds = %10, %12
  %25 = phi ptr [ %11, %10 ], [ %15, %12 ]
  %26 = sdiv i32 %1, 100
  %27 = shl nsw i32 %26, 8
  %28 = mul i32 %26, 100
  %29 = sub i32 %1, %28
  %30 = shl nsw i32 %29, 8
  %31 = sdiv i32 %30, 100
  %32 = add nsw i32 %31, %27
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %5) #19
  call void @_ZN5rally11trackSampleElRKNS_8TrackDefE(ptr nonnull sret(%"struct.rally::Sample") align 1 %5, i32 noundef %32, ptr noundef nonnull align 1 dereferenceable(13) %25) #18
  %33 = getelementptr inbounds %"struct.rally::Sample", ptr %6, i24 0, i32 1
  %34 = getelementptr inbounds %"struct.rally::Sample", ptr %5, i24 0, i32 1
  %35 = getelementptr inbounds %"struct.rally::Sample", ptr %5, i24 0, i32 3
  %36 = getelementptr inbounds %"struct.rally::Sample", ptr %5, i24 0, i32 2
  br label %37

37:                                               ; preds = %72, %24
  %38 = phi i24 [ 104, %24 ], [ %76, %72 ]
  %39 = icmp eq i24 %38, 225
  br i1 %39, label %40, label %41

40:                                               ; preds = %37
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %5) #19
  ret void

41:                                               ; preds = %37
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %6) #19
  %42 = add nsw i24 %38, -96
  %43 = getelementptr inbounds %"struct.rally::Road", ptr %0, i24 0, i32 4, i24 %42
  %44 = load i32, ptr %43, align 1, !tbaa !46
  %45 = add nsw i32 %44, %32
  %46 = load ptr, ptr %0, align 1, !tbaa !110
  call void @_ZN5rally11trackSampleElRKNS_8TrackDefE(ptr nonnull sret(%"struct.rally::Sample") align 1 %6, i32 noundef %45, ptr noundef nonnull align 1 dereferenceable(13) %46) #18
  %47 = load i32, ptr %6, align 1, !tbaa !187
  %48 = load i32, ptr %5, align 1, !tbaa !187
  %49 = sub i32 %48, %47
  %50 = load i32, ptr %33, align 1, !tbaa !189
  %51 = load i32, ptr %34, align 1, !tbaa !189
  %52 = sub nsw i32 %50, %51
  %53 = load i32, ptr %35, align 1, !tbaa !125
  %54 = mul nsw i32 %53, %49
  %55 = load i32, ptr %36, align 1, !tbaa !123
  %56 = mul nsw i32 %55, %52
  %57 = add nsw i32 %56, %54
  %58 = sdiv i32 %57, 4096
  %59 = sub nsw i32 %58, %3
  %60 = sext i24 %42 to i32
  %61 = mul nsw i32 %59, %60
  %62 = sdiv i32 %61, 50
  %63 = add nsw i32 %62, 40960
  %64 = getelementptr inbounds %"struct.rally::Road", ptr %0, i24 0, i32 5, i24 %38
  store i32 %63, ptr %64, align 1, !tbaa !46
  %65 = icmp ugt i24 %38, 115
  br i1 %65, label %66, label %72

66:                                               ; preds = %41
  %67 = getelementptr inbounds %"struct.rally::Road", ptr %0, i24 0, i32 3, i24 %42
  %68 = load i32, ptr %67, align 1, !tbaa !46
  %69 = add nsw i32 %68, %2
  %70 = srem i32 %69, 8000
  %71 = icmp slt i32 %70, 4000
  br label %72

72:                                               ; preds = %66, %41
  %73 = phi i1 [ false, %41 ], [ %71, %66 ]
  %74 = getelementptr inbounds %"struct.rally::Road", ptr %0, i24 0, i32 6, i24 %38
  %75 = zext i1 %73 to i8
  store i8 %75, ptr %74, align 1, !tbaa !12
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %6) #19
  %76 = add nuw nsw i24 %38, 1
  br label %37, !llvm.loop !225
}

; Function Attrs: minsize mustprogress nounwind optsize
define linkonce_odr dso_local noundef i24 @_ZNK5rally4Road7bandEndEi(ptr noundef nonnull align 1 dereferenceable(2167) %0, i24 noundef %1) local_unnamed_addr #4 align 2 {
  %3 = getelementptr inbounds %"struct.rally::Road", ptr %0, i24 0, i32 1
  %4 = load i8, ptr %3, align 1, !tbaa !223, !range !34
  %5 = icmp eq i8 %4, 0
  br i1 %5, label %6, label %10

6:                                                ; preds = %2
  %7 = getelementptr inbounds %"struct.rally::Road", ptr %0, i24 0, i32 6, i24 %1
  %8 = getelementptr inbounds %"struct.rally::Road", ptr %0, i24 0, i32 5, i24 %1
  %9 = tail call i24 @llvm.smax.i24(i24 %1, i24 223)
  br label %30

10:                                               ; preds = %2
  %11 = getelementptr inbounds %"struct.rally::Road", ptr %0, i24 0, i32 2
  %12 = load ptr, ptr %11, align 1, !tbaa !224
  br label %13

13:                                               ; preds = %13, %10
  %14 = phi ptr [ %12, %10 ], [ %18, %13 ]
  %15 = load i8, ptr %14, align 1, !tbaa !22
  %16 = zext i8 %15 to i24
  %17 = icmp slt i24 %16, %1
  %18 = getelementptr inbounds i8, ptr %14, i24 1
  br i1 %17, label %13, label %19, !llvm.loop !226

19:                                               ; preds = %13
  %20 = getelementptr inbounds %"struct.rally::Road", ptr %0, i24 0, i32 6, i24 %1
  br label %21

21:                                               ; preds = %19, %24
  %22 = phi i24 [ %25, %24 ], [ %1, %19 ]
  %23 = icmp eq i24 %22, %16
  br i1 %23, label %67, label %24

24:                                               ; preds = %21
  %25 = add i24 %22, 1
  %26 = getelementptr inbounds %"struct.rally::Road", ptr %0, i24 0, i32 6, i24 %25
  %27 = load i8, ptr %26, align 1, !tbaa !12, !range !34
  %28 = load i8, ptr %20, align 1, !tbaa !12, !range !34
  %29 = icmp eq i8 %27, %28
  br i1 %29, label %21, label %67, !llvm.loop !227

30:                                               ; preds = %66, %6
  %31 = phi i24 [ %1, %6 ], [ %34, %66 ]
  %32 = icmp eq i24 %31, %9
  br i1 %32, label %67, label %33

33:                                               ; preds = %30
  %34 = add i24 %31, 1
  %35 = getelementptr inbounds %"struct.rally::Road", ptr %0, i24 0, i32 6, i24 %34
  %36 = load i8, ptr %35, align 1, !tbaa !12, !range !34
  %37 = load i8, ptr %7, align 1, !tbaa !12, !range !34
  %38 = icmp eq i8 %36, %37
  br i1 %38, label %39, label %67

39:                                               ; preds = %33
  %40 = add nsw i24 %31, 2
  %41 = sub nsw i24 %40, %1
  %42 = sext i24 %41 to i32
  %43 = getelementptr inbounds %"struct.rally::Road", ptr %0, i24 0, i32 5, i24 %40
  %44 = shl nsw i32 %42, 8
  %45 = sub nsw i32 0, %44
  br label %46

46:                                               ; preds = %49, %39
  %47 = phi i24 [ %1, %39 ], [ %50, %49 ]
  %48 = icmp sgt i24 %47, %31
  br i1 %48, label %66, label %49

49:                                               ; preds = %46
  %50 = add nsw i24 %47, 1
  %51 = load i32, ptr %8, align 1, !tbaa !46
  %52 = getelementptr inbounds %"struct.rally::Road", ptr %0, i24 0, i32 5, i24 %50
  %53 = load i32, ptr %52, align 1, !tbaa !46
  %54 = sub nsw i32 %51, %53
  %55 = mul nsw i32 %54, %42
  %56 = load i32, ptr %43, align 1, !tbaa !46
  %57 = sub nsw i32 %56, %51
  %58 = sub nsw i24 %50, %1
  %59 = sext i24 %58 to i32
  %60 = mul nsw i32 %57, %59
  %61 = add nsw i32 %60, %55
  %62 = icmp sgt i32 %61, %44
  %63 = icmp slt i32 %61, %45
  %64 = select i1 %62, i1 true, i1 %63
  br i1 %64, label %65, label %46, !llvm.loop !228

65:                                               ; preds = %49
  br i1 %48, label %66, label %67

66:                                               ; preds = %46, %65
  br label %30

67:                                               ; preds = %24, %21, %65, %33, %30
  %68 = phi i24 [ %31, %65 ], [ %31, %33 ], [ %9, %30 ], [ %22, %24 ], [ %16, %21 ]
  ret i24 %68
}

; Function Attrs: minsize mustprogress nounwind optsize
define linkonce_odr dso_local void @_ZNK5rally4Road5stripERNS_6StreamEiiiii(ptr noundef nonnull align 1 dereferenceable(2167) %0, ptr noundef nonnull align 1 dereferenceable(4100) %1, i24 noundef %2, i24 noundef %3, i24 noundef %4, i24 noundef %5, i24 noundef %6) local_unnamed_addr #4 align 2 {
  %8 = getelementptr inbounds %"struct.rally::Road", ptr %0, i24 0, i32 5, i24 %2
  %9 = load i32, ptr %8, align 1, !tbaa !46
  %10 = sdiv i32 %9, 256
  %11 = trunc i32 %10 to i24
  %12 = getelementptr inbounds %"struct.rally::Road", ptr %0, i24 0, i32 5, i24 %3
  %13 = load i32, ptr %12, align 1, !tbaa !46
  %14 = sdiv i32 %13, 256
  %15 = trunc i32 %14 to i24
  %16 = add nsw i24 %2, -96
  %17 = mul nsw i24 %16, %4
  %18 = sdiv i24 %17, 50
  %19 = add nsw i24 %18, %11
  %20 = mul nsw i24 %16, %5
  %21 = sdiv i24 %20, 50
  %22 = add nsw i24 %21, %11
  %23 = add nsw i24 %3, -96
  %24 = mul nsw i24 %23, %4
  %25 = sdiv i24 %24, 50
  %26 = add nsw i24 %25, %15
  %27 = mul nsw i24 %23, %5
  %28 = sdiv i24 %27, 50
  %29 = add nsw i24 %28, %15
  tail call void @_ZN5rally6Stream4quadEiiiiiii(ptr noundef nonnull align 1 dereferenceable(4100) %1, i24 noundef %19, i24 noundef %22, i24 noundef %2, i24 noundef %26, i24 noundef %29, i24 noundef %3, i24 noundef %6) #18
  ret void
}

; Function Attrs: minsize mustprogress nounwind optsize
define linkonce_odr dso_local void @_ZN5rally6Stream4quadEiiiiiii(ptr noundef nonnull align 1 dereferenceable(4100) %0, i24 noundef %1, i24 noundef %2, i24 noundef %3, i24 noundef %4, i24 noundef %5, i24 noundef %6, i24 noundef %7) local_unnamed_addr #4 align 2 {
  tail call void @_ZN5rally6Stream5colorEi(ptr noundef nonnull align 1 dereferenceable(4100) %0, i24 noundef %7) #18
  tail call void @_ZN5rally6Stream4plotEiii(ptr noundef nonnull align 1 dereferenceable(4100) %0, i24 noundef 4, i24 noundef %1, i24 noundef %3) #18
  tail call void @_ZN5rally6Stream4plotEiii(ptr noundef nonnull align 1 dereferenceable(4100) %0, i24 noundef 4, i24 noundef %2, i24 noundef %3) #18
  tail call void @_ZN5rally6Stream4plotEiii(ptr noundef nonnull align 1 dereferenceable(4100) %0, i24 noundef 85, i24 noundef %4, i24 noundef %6) #18
  tail call void @_ZN5rally6Stream4plotEiii(ptr noundef nonnull align 1 dereferenceable(4100) %0, i24 noundef 85, i24 noundef %5, i24 noundef %6) #18
  ret void
}

; Function Attrs: nofree nounwind
declare noundef i24 @puts(ptr nocapture noundef readonly) local_unnamed_addr #14

; Function Attrs: nocallback nofree nosync nounwind readnone speculatable willreturn
declare i24 @llvm.smin.i24(i24, i24) #15

; Function Attrs: nocallback nofree nosync nounwind readnone speculatable willreturn
declare i24 @llvm.smax.i24(i24, i24) #15

; Function Attrs: nocallback nofree nosync nounwind readnone speculatable willreturn
declare i32 @llvm.smax.i32(i32, i32) #15

; Function Attrs: nocallback nofree nosync nounwind readnone speculatable willreturn
declare i32 @llvm.umin.i32(i32, i32) #15

; Function Attrs: nocallback nofree nosync nounwind readnone speculatable willreturn
declare i24 @llvm.abs.i24(i24, i1 immarg) #15

; Function Attrs: nocallback nofree nosync nounwind readnone speculatable willreturn
declare i32 @llvm.smin.i32(i32, i32) #15

; Function Attrs: nocallback nofree nosync nounwind readnone speculatable willreturn
declare i24 @llvm.umin.i24(i24, i24) #15

; Function Attrs: nocallback nofree nosync nounwind readnone speculatable willreturn
declare i16 @llvm.smin.i16(i16, i16) #15

; Function Attrs: nocallback nofree nosync nounwind readnone speculatable willreturn
declare i16 @llvm.smax.i16(i16, i16) #15

; Function Attrs: nocallback nofree nosync nounwind readnone speculatable willreturn
declare i32 @llvm.abs.i32(i32, i1 immarg) #15

; Function Attrs: nocallback nofree nosync nounwind readnone speculatable willreturn
declare i16 @llvm.abs.i16(i16, i1 immarg) #15

; Function Attrs: nocallback nofree nosync nounwind readnone speculatable willreturn
declare i24 @llvm.umax.i24(i24, i24) #15

; Function Attrs: argmemonly nocallback nofree nounwind willreturn writeonly
declare void @llvm.memset.p0.i24(ptr nocapture writeonly, i8, i24, i1 immarg) #16

attributes #0 = { minsize nounwind optsize "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="ez80" }
attributes #1 = { argmemonly mustprogress nocallback nofree nosync nounwind willreturn }
attributes #2 = { minsize optsize "frame-pointer"="none" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="ez80" }
attributes #3 = { inlinehint minsize mustprogress nounwind optsize "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="ez80" }
attributes #4 = { minsize mustprogress nounwind optsize "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="ez80" }
attributes #5 = { minsize mustprogress nofree norecurse nounwind optsize "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="ez80" }
attributes #6 = { argmemonly mustprogress nocallback nofree nounwind willreturn }
attributes #7 = { inlinehint minsize nounwind optsize "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="ez80" }
attributes #8 = { minsize mustprogress norecurse nounwind optsize "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="ez80" }
attributes #9 = { minsize nofree nounwind optsize "frame-pointer"="none" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="ez80" }
attributes #10 = { minsize mustprogress nofree norecurse nosync nounwind optsize readonly willreturn "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="ez80" }
attributes #11 = { argmemonly minsize mustprogress nofree nounwind optsize willreturn "frame-pointer"="none" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="ez80" }
attributes #12 = { argmemonly minsize mustprogress nofree nounwind optsize readonly willreturn "frame-pointer"="none" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="ez80" }
attributes #13 = { argmemonly mustprogress nocallback nofree nounwind willreturn writeonly }
attributes #14 = { nofree nounwind }
attributes #15 = { nocallback nofree nosync nounwind readnone speculatable willreturn }
attributes #16 = { argmemonly nocallback nofree nounwind willreturn writeonly }
attributes #17 = { minsize nounwind optsize }
attributes #18 = { minsize optsize }
attributes #19 = { nounwind }

!llvm.module.flags = !{!0}
!llvm.ident = !{!1}

!0 = !{i32 1, !"wchar_size", i32 2}
!1 = !{!"clang version 15.0.7 (https://github.com/AgonPlatform/agon-llvm-project.git c76386c0083e6a6236ff774275227e2389f85538)"}
!2 = !{!3, !9, i64 27}
!3 = !{!"_ZTSN5rally6MotionE", !4, i64 0, !7, i64 3, !7, i64 7, !7, i64 11, !7, i64 15, !7, i64 19, !8, i64 23, !8, i64 25, !9, i64 27, !10, i64 30}
!4 = !{!"any pointer", !5, i64 0}
!5 = !{!"omnipotent char", !6, i64 0}
!6 = !{!"Simple C++ TBAA"}
!7 = !{!"long", !5, i64 0}
!8 = !{!"short", !5, i64 0}
!9 = !{!"int", !5, i64 0}
!10 = !{!"bool", !5, i64 0}
!11 = !{!4, !4, i64 0}
!12 = !{!10, !10, i64 0}
!13 = !{!14, !16, i64 9}
!14 = !{!"_ZTSN5rally4game5RulesE", !15, i64 0, !16, i64 9, !17, i64 10, !7, i64 11, !7, i64 15, !7, i64 19, !7, i64 23, !7, i64 27, !7, i64 31, !7, i64 35, !7, i64 39, !7, i64 43, !7, i64 47, !7, i64 51, !8, i64 55, !8, i64 57, !5, i64 59, !5, i64 60, !5, i64 61, !9, i64 62}
!15 = !{!"_ZTSN5rally4game8SettingsE", !8, i64 0, !8, i64 2, !8, i64 4, !8, i64 6, !5, i64 8}
!16 = !{!"_ZTSN5rally4game6PolicyE", !5, i64 0}
!17 = !{!"_ZTSN5rally4game5PhaseE", !5, i64 0}
!18 = distinct !{!18, !19}
!19 = !{!"llvm.loop.mustprogress"}
!20 = distinct !{!20, !19}
!21 = distinct !{!21, !19}
!22 = !{!5, !5, i64 0}
!23 = distinct !{!23, !19}
!24 = !{!25, !9, i64 4096}
!25 = !{!"_ZTSN5rally6StreamE", !5, i64 0, !9, i64 4096, !10, i64 4099}
!26 = !{!25, !10, i64 4099}
!27 = distinct !{!27, !19}
!28 = distinct !{!28, !19}
!29 = distinct !{!29, !19}
!30 = distinct !{!30, !19}
!31 = distinct !{!31, !19}
!32 = distinct !{!32, !19}
!33 = distinct !{!33, !19}
!34 = !{i8 0, i8 2}
!35 = distinct !{!35, !19}
!36 = !{!14, !17, i64 10}
!37 = !{!14, !7, i64 11}
!38 = !{!14, !8, i64 55}
!39 = !{!40, !7, i64 6}
!40 = !{!"_ZTSN5rally8TrackDefE", !4, i64 0, !9, i64 3, !7, i64 6, !4, i64 10}
!41 = !{!3, !8, i64 23}
!42 = !{!14, !9, i64 62}
!43 = distinct !{!43, !19}
!44 = !{!3, !7, i64 11}
!45 = !{!3, !10, i64 30}
!46 = !{!7, !7, i64 0}
!47 = !{!48, !7, i64 8}
!48 = !{!"_ZTSN5rally4game7RaceCarE", !10, i64 0, !8, i64 1, !5, i64 3, !7, i64 4, !7, i64 8, !7, i64 12, !7, i64 16, !49, i64 20}
!49 = !{!"_ZTSN5rally4game11RouteCursorE", !5, i64 0, !8, i64 1, !8, i64 3, !7, i64 5}
!50 = !{!48, !7, i64 4}
!51 = !{!48, !7, i64 16}
!52 = !{!14, !7, i64 43}
!53 = !{!3, !7, i64 7}
!54 = !{!3, !8, i64 25}
!55 = !{!48, !10, i64 0}
!56 = !{!48, !8, i64 1}
!57 = !{!8, !8, i64 0}
!58 = distinct !{!58, !19}
!59 = !{!14, !7, i64 15}
!60 = !{!3, !7, i64 15}
!61 = !{!62, !8, i64 0}
!62 = !{!"_ZTSN5rally4game5CrashE", !8, i64 0, !8, i64 2}
!63 = !{!3, !7, i64 19}
!64 = !{!14, !7, i64 39}
!65 = distinct !{!65, !19}
!66 = !{!14, !5, i64 61}
!67 = distinct !{!67, !19}
!68 = !{!69, !9, i64 23}
!69 = !{!"_ZTSN5rally3r1810SceneStateE", !9, i64 0, !9, i64 3, !9, i64 6, !9, i64 9, !10, i64 12, !9, i64 13, !9, i64 16, !9, i64 19, !10, i64 22, !9, i64 23, !5, i64 26}
!70 = !{!69, !9, i64 0}
!71 = !{!69, !9, i64 3}
!72 = !{!69, !10, i64 12}
!73 = !{!69, !9, i64 6}
!74 = !{!69, !9, i64 9}
!75 = distinct !{!75, !19}
!76 = distinct !{!76, !19}
!77 = !{!78, !9, i64 6}
!78 = !{!"_ZTSN5rally3r188CarStateE", !9, i64 0, !9, i64 3, !9, i64 6, !9, i64 9, !9, i64 12, !9, i64 15, !9, i64 18, !10, i64 21}
!79 = !{!80, !9, i64 6}
!80 = !{!"_ZTSN5rally4game8SignPoseE", !9, i64 0, !9, i64 3, !9, i64 6, !9, i64 9}
!81 = !{!80, !9, i64 9}
!82 = !{!80, !9, i64 0}
!83 = !{!80, !9, i64 3}
!84 = distinct !{!84, !19}
!85 = !{!78, !9, i64 3}
!86 = !{!78, !9, i64 9}
!87 = !{!78, !9, i64 12}
!88 = !{!78, !9, i64 0}
!89 = !{!78, !9, i64 15}
!90 = !{!78, !9, i64 18}
!91 = !{!69, !9, i64 19}
!92 = !{!9, !9, i64 0}
!93 = distinct !{!93, !19}
!94 = !{!62, !8, i64 2}
!95 = !{!69, !9, i64 13}
!96 = !{!69, !10, i64 22}
!97 = !{!69, !9, i64 16}
!98 = !{!14, !5, i64 60}
!99 = !{!100, !9, i64 8}
!100 = !{!"_ZTSN5rally14SceneryHistoryE", !5, i64 0, !5, i64 6, !9, i64 8}
!101 = !{!14, !7, i64 31}
!102 = !{!103, !7, i64 0}
!103 = !{!"_ZTSN5rally4game6RecordE", !7, i64 0, !7, i64 4}
!104 = !{!14, !7, i64 19}
!105 = !{!14, !7, i64 23}
!106 = !{!14, !7, i64 27}
!107 = !{!14, !5, i64 59}
!108 = !{!14, !5, i64 8}
!109 = !{!14, !8, i64 57}
!110 = !{!111, !4, i64 0}
!111 = !{!"_ZTSN5rally4RoadE", !4, i64 0, !10, i64 3, !4, i64 4, !5, i64 7, !5, i64 523, !5, i64 1039, !5, i64 1939, !9, i64 2164}
!112 = !{i64 0, i64 1, !12}
!113 = !{!3, !4, i64 0}
!114 = !{i64 0, i64 2, !57, i64 2, i64 2, !57}
!115 = !{i64 0, i64 2, !57}
!116 = !{!117, !10, i64 0}
!117 = !{!"_ZTSN5rally4game6EngineE", !10, i64 0, !9, i64 1}
!118 = !{!117, !9, i64 1}
!119 = !{!120, !7, i64 0}
!120 = !{!"_ZTS6SYSVAR", !7, i64 0, !5, i64 4, !5, i64 5, !5, i64 6, !5, i64 7, !5, i64 8, !5, i64 9, !5, i64 10, !5, i64 13, !5, i64 14, !8, i64 15, !8, i64 17, !5, i64 19, !5, i64 20, !5, i64 21, !5, i64 22, !5, i64 23, !5, i64 24, !5, i64 25, !121, i64 26, !8, i64 32, !8, i64 34, !8, i64 36, !5, i64 38, !5, i64 39, !5, i64 40, !8, i64 41, !8, i64 43, !5, i64 45, !5, i64 46, !8, i64 47, !8, i64 49}
!121 = !{!"_ZTS14SYSVAR_RTCDATA", !5, i64 0, !5, i64 1, !5, i64 2, !5, i64 3, !5, i64 4, !5, i64 5}
!122 = distinct !{!122, !19}
!123 = !{!124, !7, i64 8}
!124 = !{!"_ZTSN5rally6SampleE", !7, i64 0, !7, i64 4, !7, i64 8, !7, i64 12}
!125 = !{!124, !7, i64 12}
!126 = distinct !{!126, !19}
!127 = distinct !{!127, !19}
!128 = !{!129, !9, i64 0}
!129 = !{!"_ZTSN5rally10DemoDriverE", !9, i64 0}
!130 = !{!3, !7, i64 3}
!131 = !{!132, !9, i64 0}
!132 = !{!"_ZTSN5rally13SceneryUpdateE", !9, i64 0, !9, i64 3, !9, i64 6, !10, i64 9}
!133 = !{!132, !9, i64 3}
!134 = !{!132, !9, i64 6}
!135 = !{!132, !10, i64 9}
!136 = !{!137, !7, i64 0}
!137 = !{!"_ZTSN5rally8OpponentE", !7, i64 0, !9, i64 4, !9, i64 7}
!138 = distinct !{!138, !19}
!139 = distinct !{!139, !19}
!140 = distinct !{!140, !19}
!141 = !{!142, !5, i64 0}
!142 = !{!"_ZTSN5rally3r184PoseE", !5, i64 0, !10, i64 1}
!143 = !{!142, !10, i64 1}
!144 = !{!137, !9, i64 7}
!145 = !{!48, !8, i64 23}
!146 = !{!78, !10, i64 21}
!147 = !{!148, !9, i64 24}
!148 = !{!"_ZTSN5rally4game10BillboardsE", !5, i64 0, !9, i64 24}
!149 = !{i64 0, i64 3, !92, i64 3, i64 3, !92, i64 6, i64 3, !92, i64 9, i64 3, !92}
!150 = !{i64 0, i64 3, !92, i64 3, i64 3, !92, i64 6, i64 3, !92}
!151 = !{i64 0, i64 3, !92, i64 3, i64 3, !92}
!152 = !{i64 0, i64 3, !92}
!153 = distinct !{!153, !19}
!154 = !{!111, !9, i64 2164}
!155 = distinct !{!155, !19}
!156 = !{i24 0, i24 2}
!157 = distinct !{!157, !19}
!158 = !{i64 0, i64 4, !46, i64 4, i64 4, !46}
!159 = !{i64 0, i64 4, !46}
!160 = distinct !{!160, !19}
!161 = distinct !{!161, !19}
!162 = distinct !{!162, !19}
!163 = distinct !{!163, !19}
!164 = !{!165, !16, i64 183}
!165 = !{!"_ZTSN5rally4game11RaceTrafficE", !5, i64 0, !49, i64 174, !16, i64 183, !7, i64 184, !7, i64 188, !7, i64 192, !5, i64 196}
!166 = !{!165, !7, i64 184}
!167 = !{!165, !7, i64 188}
!168 = !{!165, !7, i64 192}
!169 = !{!165, !5, i64 196}
!170 = !{i64 0, i64 1, !22, i64 1, i64 2, !57, i64 3, i64 2, !57, i64 5, i64 4, !46}
!171 = !{i64 0, i64 2, !57, i64 2, i64 2, !57, i64 4, i64 4, !46}
!172 = !{i64 0, i64 2, !57, i64 2, i64 4, !46}
!173 = distinct !{!173, !19}
!174 = !{!48, !5, i64 3}
!175 = !{!48, !7, i64 12}
!176 = distinct !{!176, !19}
!177 = !{!165, !7, i64 179}
!178 = !{!103, !7, i64 4}
!179 = !{i64 0, i64 2, !57, i64 2, i64 2, !57, i64 4, i64 2, !57, i64 6, i64 2, !57, i64 8, i64 1, !22}
!180 = !{!14, !7, i64 47}
!181 = !{!14, !7, i64 51}
!182 = !{!14, !8, i64 0}
!183 = !{!40, !9, i64 3}
!184 = !{!40, !4, i64 0}
!185 = !{!186, !8, i64 0}
!186 = !{!"_ZTSN5rally10TrackPointE", !8, i64 0, !8, i64 2, !8, i64 4, !8, i64 6}
!187 = !{!124, !7, i64 0}
!188 = !{!186, !8, i64 2}
!189 = !{!124, !7, i64 4}
!190 = !{!186, !8, i64 4}
!191 = !{!186, !8, i64 6}
!192 = distinct !{!192, !19}
!193 = !{!14, !7, i64 35}
!194 = !{!14, !8, i64 6}
!195 = !{!49, !8, i64 1}
!196 = !{!49, !5, i64 0}
!197 = !{!198, !8, i64 0}
!198 = !{!"_ZTSN5rally4game11RouteRecordE", !8, i64 0, !8, i64 2, !8, i64 4, !8, i64 6}
!199 = !{!198, !8, i64 6}
!200 = !{!49, !8, i64 3}
!201 = !{!198, !8, i64 2}
!202 = !{!49, !7, i64 5}
!203 = distinct !{!203, !19}
!204 = !{!14, !8, i64 4}
!205 = !{!14, !8, i64 2}
!206 = !{!207, !7, i64 2167}
!207 = !{!"_ZTSN5rally10DirectRoadE", !111, i64 0, !7, i64 2167, !7, i64 2171, !124, i64 2175}
!208 = !{!207, !7, i64 2175}
!209 = !{!207, !7, i64 2179}
!210 = !{!207, !7, i64 2187}
!211 = !{!207, !7, i64 2183}
!212 = !{!207, !7, i64 2171}
!213 = distinct !{!213, !19}
!214 = distinct !{!214, !19}
!215 = !{i64 0, i64 120, !22, i64 120, i64 120, !22}
!216 = distinct !{!216, !19}
!217 = distinct !{!217, !19}
!218 = distinct !{!218, !19}
!219 = distinct !{!219, !19}
!220 = distinct !{!220, !19}
!221 = distinct !{!221, !19}
!222 = !{i64 0, i64 4, !46, i64 4, i64 4, !46, i64 8, i64 4, !46, i64 12, i64 4, !46}
!223 = !{!111, !10, i64 3}
!224 = !{!111, !4, i64 4}
!225 = distinct !{!225, !19}
!226 = distinct !{!226, !19}
!227 = distinct !{!227, !19}
!228 = distinct !{!228, !19}
