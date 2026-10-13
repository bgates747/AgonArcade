import os
import sys
import unittest
from pathlib import Path
os.environ['SDL_VIDEODRIVER'] = 'dummy'
os.environ['SDL_AUDIODRIVER'] = 'dummy'
sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
import pygame
from game import Game, Shot, Enemy, PALETTE, WIDTH, HEIGHT, GROUND, BASE


class RescueTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        pygame.display.init()
        pygame.font.init()

    def setUp(self):
        self.g = Game()
        self.g.state = 'playing'
        self.g.tank_timer = self.g.jet_timer = 10000

    def advance(self, seconds):
        for _ in range(round(seconds*120)):
            self.g.update(1/120)

    def test_entire_rescue_mission(self):
        g = self.g
        for b in g.barracks:
            g.shots.append(Shot(b.x, GROUND-40, 0, 0, 'bomb'))
            self.advance(.01)
            self.assertTrue(b.opened)
            g.x, g.y = b.x, GROUND-24
            self.advance(6)
            self.assertEqual(g.cargo, 16)
            g.x = BASE
            self.advance(3)
            self.assertEqual(g.cargo, 0)
        self.assertEqual(g.rescued, 64)
        self.assertEqual(g.lost, 0)
        self.assertEqual(g.state, 'complete')

    def test_crash_cargo_and_three_lives(self):
        g = self.g
        g.cargo = 16
        g.crash()
        self.assertEqual((g.cargo,g.lost,g.lives), (0,16,2))
        g.crash()  # cannot lose multiple lives during the same explosion
        self.assertEqual(g.lives,2)
        self.advance(2)
        g.crash()
        self.advance(2)
        g.crash()
        self.assertEqual(g.state,'over')
        self.assertEqual(g.lives,0)

    def test_hard_landing_and_soft_landing(self):
        g = self.g
        g.y,g.vy = GROUND-25,170
        self.advance(.02)
        self.assertEqual(g.lives,2)
        self.advance(2)
        g.y,g.vy = GROUND-25,20
        self.advance(.2)
        self.assertTrue(g.landed)
        self.assertEqual(g.lives,2)

    def test_weapons_enemies_and_civilians(self):
        g = self.g
        g.enemies.append(Enemy(1200,GROUND-14,'tank',1,999))
        g.shots.append(Shot(1200,GROUND-14,0,0,'bomb'))
        self.advance(.01)
        self.assertEqual(len(g.enemies),0)
        self.assertEqual(g.score,25)
        p = g.people[0]
        p.state='free'
        g.shots.append(Shot(p.x,GROUND-8,0,0,'enemy'))
        self.advance(.01)
        self.assertEqual(p.state,'lost')
        self.assertEqual(g.lost,1)
        g.invulnerable=0
        g.shots.append(Shot(g.x,g.y,0,0,'enemy'))
        self.advance(.01)
        self.assertEqual(g.lives,2)

    def test_pause_and_frame_rate_independent_flight(self):
        g = self.g
        g.paused=True
        g.update(1,{'up','right'})
        self.assertEqual(g.x,BASE)
        g.paused=False
        for _ in range(120):
            g.update(1/120,{'up','right'})
        self.assertGreater(g.x,BASE+100)
        self.assertLess(g.y,GROUND-100)
        self.assertGreaterEqual(g.y,88)

    def test_all_rendered_pixels_have_rgb222_and_binary_alpha(self):
        surface=pygame.Surface((WIDTH,HEIGHT),pygame.SRCALPHA)
        g = self.g
        scenes=['title','playing','over','complete']
        for state in scenes:
            g.state=state
            for x in (BASE,950,2400,3400):
                g.x=x
                g.camera=max(0,min(x-365,3600-WIDTH))
                g.open_barrack(g.barracks[0])
                g.enemies=[Enemy(x+100,GROUND-14,'tank',1,2),Enemy(x+200,180,'jet',-1,2)]
                g.shots=[Shot(x+50,250,0,0,'enemy'),Shot(x+100,300,0,0,'bomb')]
                g.front=x==2400
                g.draw(surface)
                # Read packed pixels without NumPy or image conversion.
                colors={surface.unmap_rgb(pixel)[:4] for row in pygame.PixelArray(surface) for pixel in row}
                self.assertTrue(all(c[:3] in PALETTE and c[3] in (0,255) for c in colors),colors)
                self.assertTrue(all(c[3]==255 for c in colors))
        self.assertEqual(surface.get_size(),(848,480))


if __name__=='__main__':
    unittest.main()
