"""Original-style helicopter rescue. All artwork is drawn with RGB222 colors."""
from __future__ import annotations

import argparse
import math
import os
import random
from dataclasses import dataclass
from pathlib import Path

os.environ.setdefault('PYGAME_HIDE_SUPPORT_PROMPT', '1')
import pygame

WIDTH, HEIGHT = 848, 480
GROUND, WORLD, BASE = 410, 3600, 220
PALETTE = tuple((r, g, b) for r in range(0, 256, 85)
                for g in range(0, 256, 85) for b in range(0, 256, 85))
INK = (0, 0, 85)
WHITE = (255, 255, 255)
TEAL = (0, 255, 170)
GOLD = (255, 255, 85)
RED = (255, 85, 85)


def clamp(value, lo, hi):
    return max(lo, min(hi, value))


@dataclass
class Hostage:
    x: float
    state: str = 'waiting'


@dataclass
class Barrack:
    x: float
    opened: bool = False
    hp: int = 3


@dataclass
class Shot:
    x: float
    y: float
    vx: float
    vy: float
    kind: str
    life: float = 3.0


@dataclass
class Enemy:
    x: float
    y: float
    kind: str
    direction: int
    cooldown: float
    hp: int = 2


@dataclass
class Spark:
    x: float
    y: float
    vx: float
    vy: float
    life: float
    color: tuple


class Game:
    def __init__(self, seed=22):
        self.rng = random.Random(seed)
        self.font = pygame.font.Font(None, 24)
        self.small = pygame.font.Font(None, 18)
        self.big = pygame.font.Font(None, 62)
        self.reset()

    def reset(self):
        self.barracks = [Barrack(x) for x in (950, 1650, 2350, 3050)]
        self.people = [Hostage(b.x + (i % 8 - 4) * 7) for b in self.barracks for i in range(16)]
        self.shots, self.enemies, self.sparks = [], [], []
        self.rescued = self.lost = self.cargo = self.score = 0
        self.lives = 3
        self.time = self.camera = self.cooldown = self.transfer = 0.0
        self.tank_timer, self.jet_timer = 6.0, 22.0
        self.state, self.paused = 'title', False
        self.banner, self.banner_time = '', 0.0
        self.spawn()

    def spawn(self):
        self.x, self.y = float(BASE), float(GROUND - 24)
        self.vx = self.vy = 0.0
        self.facing = 1
        self.front = False
        self.invulnerable = 3.0
        self.respawn = 0.0

    @property
    def landed(self):
        return self.y >= GROUND - 24 and abs(self.vx) < 28 and abs(self.vy) < 1

    def message(self, text):
        self.banner, self.banner_time = text, 3.0

    def burst(self, x, y, size=22):
        for _ in range(size):
            a = self.rng.uniform(0, math.tau)
            speed = self.rng.uniform(35, 130)
            self.sparks.append(Spark(x, y, math.cos(a)*speed, math.sin(a)*speed,
                                     self.rng.uniform(.2, .8), self.rng.choice((GOLD, RED, WHITE))))

    def crash(self):
        if self.respawn or self.state != 'playing':
            return
        self.burst(self.x, self.y, 45)
        self.lost += self.cargo
        self.cargo = 0
        self.lives -= 1
        self.shots.clear()
        if self.lives == 0:
            self.state = 'over'
        else:
            self.respawn = 1.5
            self.message('CHOPPER LOST  /  NEW SORTIE')

    def fire(self, bomb=False):
        if self.cooldown > 0 or self.respawn:
            return
        if bomb or self.front:
            self.shots.append(Shot(self.x, self.y+15, self.vx*.4, 120, 'bomb'))
            self.cooldown = .32
        else:
            self.shots.append(Shot(self.x+self.facing*32, self.y, self.facing*560, 0, 'gun'))
            self.cooldown = .13

    def open_barrack(self, b):
        b.opened = True
        self.burst(b.x, GROUND - 30)
        for p in self.people:
            if p.state == 'waiting' and abs(p.x-b.x) < 70:
                p.state = 'free'
        self.message('BARRACK OPEN  /  LAND NEAR THE SURVIVORS')

    def transfer_people(self, dt):
        self.transfer -= dt
        if not self.landed:
            return
        if abs(self.x-BASE) < 110 and self.cargo:
            if self.transfer <= 0:
                self.cargo -= 1
                self.rescued += 1
                self.score += 100
                self.transfer = .12
            return
        for p in self.people:
            if p.state == 'free' and self.cargo < 16 and abs(p.x-self.x) < 24 and self.transfer <= 0:
                p.state = 'aboard'
                self.cargo += 1
                self.transfer = .16
                if self.cargo == 16:
                    self.message('CABIN FULL  /  RETURN TO BASE')
                break

    def update(self, dt, controls=frozenset()):
        if self.state != 'playing' or self.paused:
            return
        self.time += dt
        self.cooldown = max(0, self.cooldown-dt)
        self.banner_time = max(0, self.banner_time-dt)
        self.invulnerable = max(0, self.invulnerable-dt)
        if self.respawn:
            self.respawn -= dt
            if self.respawn <= 0:
                self.spawn()
        else:
            horizontal = int('right' in controls)-int('left' in controls)
            vertical = int('down' in controls)-int('up' in controls)
            self.vx = clamp(self.vx+horizontal*430*dt, -240, 240) * math.exp(-1.7*dt)
            self.vy = clamp(self.vy+vertical*430*dt, -175, 175) * math.exp(-2.6*dt)
            if horizontal and not self.front:
                self.facing = horizontal
            self.x = clamp(self.x+self.vx*dt, 40, WORLD-40)
            self.y += self.vy*dt
            if self.y < 88:
                self.y, self.vy = 88, max(0, self.vy)
            if self.y >= GROUND-24:
                if self.vy > 115 or abs(self.vx) > 165:
                    self.crash()
                self.y, self.vy = GROUND-24, 0
            if 'fire' in controls:
                self.fire()
            if 'bomb' in controls:
                self.fire(True)
            self.transfer_people(dt)
        for p in self.people:
            if p.state == 'free' and self.landed and self.cargo < 16 and abs(p.x-self.x) < 160:
                p.x += clamp(self.x-p.x, -38*dt, 38*dt)
        self.tank_timer -= dt
        self.jet_timer -= dt
        if self.tank_timer <= 0:
            if len([e for e in self.enemies if e.kind == 'tank']) < 6:
                x = clamp(self.x+self.rng.choice((-1, 1))*self.rng.uniform(400, 650), 600, WORLD-70)
                self.enemies.append(Enemy(x, GROUND-14, 'tank', 1, 2.0))
            self.tank_timer = max(3, 7-self.rescued*.04)
        if self.jet_timer <= 0:
            side = self.rng.choice((-1, 1))
            self.enemies.append(Enemy(self.x-side*650, self.rng.uniform(130, 270), 'jet', side, 1, 1))
            self.jet_timer = max(8, 22-self.rescued*.15)
        for e in self.enemies[:]:
            e.cooldown -= dt
            if e.kind == 'tank':
                e.direction = 1 if self.x > e.x else -1
                e.x = clamp(e.x+e.direction*22*dt, 590, WORLD-60)
                if e.cooldown <= 0 and abs(e.x-self.x) < 650 and not self.respawn:
                    dx, dy = self.x-e.x, self.y-e.y
                    length = max(1, math.hypot(dx, dy))
                    self.shots.append(Shot(e.x, e.y-12, dx/length*160, dy/length*160, 'enemy', 5))
                    e.cooldown = self.rng.uniform(2.3, 3.8)
            else:
                e.x += e.direction*280*dt
                if e.cooldown <= 0:
                    self.shots.append(Shot(e.x, e.y+10, e.direction*30, 175, 'enemy'))
                    e.cooldown = 1.2
                if e.x < -800 or e.x > WORLD+800:
                    self.enemies.remove(e)
                    continue
            if not self.respawn and not self.invulnerable and abs(e.x-self.x)<38 and abs(e.y-self.y)<26:
                self.crash()
        for s in self.shots[:]:
            s.life -= dt
            s.x += s.vx*dt
            s.y += s.vy*dt
            if s.kind == 'bomb':
                s.vy += 240*dt
            hit = False
            if s.kind == 'enemy':
                if not self.respawn and not self.invulnerable and abs(s.x-self.x)<29 and abs(s.y-self.y)<18:
                    self.crash()
                    break
                for p in self.people:
                    if p.state == 'free' and abs(p.x-s.x)<7 and abs(s.y-(GROUND-8))<12:
                        p.state = 'lost'
                        self.lost += 1
                        hit = True
                        break
            else:
                for b in self.barracks:
                    if not b.opened and abs(s.x-b.x)<53 and GROUND-55 < s.y < GROUND:
                        b.hp -= 3 if s.kind == 'bomb' else 1
                        if b.hp <= 0:
                            self.open_barrack(b)
                        hit = True
                        break
                if not hit:
                    for e in self.enemies[:]:
                        if abs(s.x-e.x)<30 and abs(s.y-e.y)<20:
                            e.hp -= 2 if s.kind == 'bomb' else 1
                            if e.hp <= 0:
                                self.burst(e.x, e.y)
                                self.enemies.remove(e)
                                self.score += 25 if e.kind == 'tank' else 50
                            hit = True
                            break
            if hit or s.y >= GROUND or s.life <= 0 or not 0 < s.x < WORLD:
                if s.kind == 'bomb':
                    self.burst(s.x, min(s.y, GROUND), 12)
                if s in self.shots:
                    self.shots.remove(s)
        for s in self.sparks[:]:
            s.life -= dt
            s.x += s.vx*dt
            s.y += s.vy*dt
            s.vy += 100*dt
            if s.life <= 0:
                self.sparks.remove(s)
        self.camera = clamp(self.x-WIDTH*.43, 0, WORLD-WIDTH)
        if self.rescued+self.lost == 64 and self.cargo == 0:
            self.state = 'complete'

    def text(self, surface, text, pos, color=WHITE, font=None, center=False):
        # antialias=False is essential: glyph edges are binary coverage.
        glyphs = (font or self.font).render(text, False, color)
        rect = glyphs.get_rect(center=pos) if center else glyphs.get_rect(topleft=pos)
        surface.blit(glyphs, rect)

    def draw(self, surface):
        surface.fill(INK)
        # Flat-color sky bands, parallax silhouettes and hard-edged pixel clouds.
        pygame.draw.rect(surface, (0, 85, 170), (0, 150, WIDTH, 200))
        pygame.draw.rect(surface, (85, 170, 170), (0, 270, WIDTH, 140))
        for i in range(12):
            x = int(i*170-self.camera*.18) % (WIDTH+180)-90
            y = 100+(i%3)*36
            pygame.draw.rect(surface, (85, 170, 255), (x, y, 70, 8))
            pygame.draw.rect(surface, (85, 170, 255), (x+20, y-8, 32, 8))
        for i in range(19):
            x = int(i*190-self.camera*.35) % (WIDTH+240)-120
            pygame.draw.polygon(surface, (0, 85, 85), [(x-100,GROUND),(x+20,255+(i%4)*22),(x+130,GROUND)])
        pygame.draw.rect(surface, (85, 85, 0), (0, GROUND, WIDTH, 70))
        pygame.draw.rect(surface, (170, 170, 85), (0, GROUND, WIDTH, 5))
        for x in range(0, WORLD, 80):
            sx = int(x-self.camera)
            if -20 < sx < WIDTH:
                pygame.draw.rect(surface, (170, 170, 0), (sx,GROUND+20+(x//80%3)*12,14,3))
        bx = int(BASE-self.camera)
        pygame.draw.rect(surface, (85, 85, 170), (bx-95,GROUND-74,76,74))
        pygame.draw.rect(surface, WHITE, (bx-95,GROUND-74,76,6))
        pygame.draw.rect(surface, INK, (bx-78,GROUND-35,40,35))
        pygame.draw.rect(surface, TEAL, (bx-10,GROUND-3,115,3))
        self.text(surface, 'H', (bx+42,GROUND-27), TEAL)
        self.text(surface, 'RESCUE BASE', (bx-104,GROUND-94), TEAL, self.small)
        pygame.draw.line(surface, WHITE, (bx-115,GROUND),(bx-115,GROUND-110),2)
        pygame.draw.polygon(surface, TEAL, [(bx-115,GROUND-110),(bx-86,GROUND-103),(bx-115,GROUND-96)])
        for n,b in enumerate(self.barracks):
            x = int(b.x-self.camera)
            if not -100<x<WIDTH+100:
                continue
            if b.opened:
                pygame.draw.rect(surface, (85,85,85), (x-52,GROUND-15,104,15))
                for j in range(4):
                    pygame.draw.rect(surface, (170,85,0), (x-40+j*25,GROUND-24,10,24))
            else:
                pygame.draw.rect(surface, (170,85,0), (x-52,GROUND-51,104,51))
                pygame.draw.polygon(surface, (255,170,85), [(x-60,GROUND-51),(x,GROUND-68),(x+60,GROUND-51)])
                pygame.draw.rect(surface, INK, (x-12,GROUND-30,24,30))
                for j in (-36,26):
                    pygame.draw.rect(surface, GOLD, (x+j,GROUND-40,12,10))
            self.text(surface, f'CAMP {n+1}', (x-24,GROUND+12), GOLD, self.small)
        for p in self.people:
            if p.state != 'free':
                continue
            x = int(p.x-self.camera)
            step = 2 if int(self.time*8+p.x)%2 else -2
            pygame.draw.rect(surface, GOLD, (x-2,GROUND-15,5,5))
            pygame.draw.rect(surface, WHITE, (x-3,GROUND-10,6,6))
            pygame.draw.line(surface, WHITE,(x-2,GROUND-5),(x-3-step,GROUND),2)
            pygame.draw.line(surface, WHITE,(x+2,GROUND-5),(x+3+step,GROUND),2)
        for e in self.enemies:
            x,y=int(e.x-self.camera),int(e.y)
            if e.kind == 'tank':
                pygame.draw.rect(surface, INK,(x-27,y+4,54,10))
                pygame.draw.rect(surface,(85,170,0),(x-24,y-6,48,12))
                pygame.draw.rect(surface,(170,170,0),(x-12,y-17,24,12))
                pygame.draw.line(surface,GOLD,(x,y-12),(x+e.direction*36,y-15),4)
                for j in range(-20,24,10):
                    pygame.draw.rect(surface,(170,170,85),(x+j,y+7,5,4))
            else:
                pygame.draw.polygon(surface,RED,[(x-30*e.direction,y),(x+34*e.direction,y),(x-12*e.direction,y-9)])
                pygame.draw.polygon(surface,(170,0,0),[(x-12,y),(x-24,y+15),(x+17,y)])
                pygame.draw.rect(surface,WHITE,(x-4,y-6,12,4))
        if not self.respawn and (not self.invulnerable or int(self.time*12)%2==0):
            self.draw_chopper(surface)
        for s in self.shots:
            x,y=int(s.x-self.camera),int(s.y)
            pygame.draw.rect(surface, RED if s.kind=='enemy' else GOLD,(x-3,y-2,7 if s.kind=='gun' else 4,4))
        for s in self.sparks:
            pygame.draw.rect(surface,s.color,(int(s.x-self.camera),int(s.y),4,4))
        self.draw_hud(surface)
        if self.banner_time and self.state=='playing':
            pygame.draw.rect(surface,INK,(110,68,628,28))
            self.text(surface,self.banner,(WIDTH//2,82),GOLD,self.small,True)
        if self.state != 'playing' or self.paused:
            self.draw_overlay(surface)

    def draw_chopper(self, surface):
        x,y=int(self.x-self.camera),int(self.y)
        def poly(color, points):
            pygame.draw.polygon(surface,color,[(x+int(px)*self.facing,y+int(py)) for px,py in points])
        if self.front:
            pygame.draw.rect(surface,WHITE,(x-13,y-12,26,26))
            pygame.draw.rect(surface,TEAL,(x-9,y-9,18,10))
            pygame.draw.line(surface,WHITE,(x-27,y+19),(x+27,y+19),3)
        else:
            poly(WHITE,[(-22,-12),(12,-12),(30,0),(25,12),(-20,12),(-27,4)])
            poly((170,170,170),[(-23,1),(-56,-7),(-57,-16),(-62,-16),(-60,6),(-23,9)])
            poly(TEAL,[(4,-9),(13,-9),(23,0),(4,0)])
            poly((85,85,85),[(-16,-2),(-1,-2),(-1,9),(-16,9)])
            pygame.draw.line(surface,WHITE,(x-24,y+20),(x+29,y+20),3)
            pygame.draw.line(surface,WHITE,(x-13,y+12),(x-13,y+20),2)
            pygame.draw.line(surface,WHITE,(x+15,y+12),(x+15,y+20),2)
            tail=x-59*self.facing
            pygame.draw.line(surface,GOLD,(tail-5,y-10),(tail+5,y-1),2)
            pygame.draw.line(surface,GOLD,(tail+5,y-10),(tail-5,y-1),2)
        pygame.draw.line(surface,WHITE,(x,y-12),(x,y-22),3)
        span=48 if int(self.time*30)%2 else 29
        pygame.draw.line(surface,WHITE,(x-span,y-23),(x+span,y-23),3)

    def draw_hud(self, surface):
        pygame.draw.rect(surface,INK,(0,0,WIDTH,60))
        pygame.draw.line(surface,(85,85,170),(0,59),(WIDTH,59),2)
        for label,value,x,color in [('RESCUED',self.rescued,22,TEAL),('ON BOARD',f'{self.cargo}/16',176,GOLD),
                                    ('LOST',self.lost,344,RED),('CHOPPERS',self.lives,460,WHITE),('SCORE',f'{self.score:05}',650,WHITE)]:
            self.text(surface,label,(x,8),color,self.small)
            self.text(surface,str(value),(x,27),color)
        # Map has all four camps and an unambiguous player marker.
        pygame.draw.rect(surface,INK,(0,452,WIDTH,28))
        pygame.draw.line(surface,(85,85,170),(160,467),(680,467),2)
        for b in self.barracks:
            mx=160+int(b.x/WORLD*520)
            pygame.draw.rect(surface,TEAL if b.opened else GOLD,(mx-3,463,6,7))
        mx=160+int(self.x/WORLD*520)
        pygame.draw.polygon(surface,WHITE,[(mx,461),(mx-4,456),(mx+4,456)])
        self.text(surface,'BASE <',(22,460),TEAL,self.small)
        self.text(surface,'P: PAUSE',(735,460),WHITE,self.small)

    def draw_overlay(self, surface):
        pygame.draw.rect(surface,INK,(105,116,638,236))
        pygame.draw.rect(surface,TEAL,(105,116,638,236),2)
        if self.paused:
            title,subtitle='PAUSED','P / ESC TO RESUME'
        elif self.state=='title':
            title,subtitle='CHOPLIFTER','RESCUE 64 HOSTAGES. BRING THEM HOME.'
        elif self.state=='complete':
            title,subtitle='MISSION COMPLETE',f'{self.rescued} RESCUED  /  {self.lost} LOST  /  SCORE {self.score}'
        else:
            title,subtitle='SORTIES EXHAUSTED',f'{self.rescued} RESCUED  /  {self.lost} LOST  /  SCORE {self.score}'
        self.text(surface,title,(424,164),TEAL,self.big,True)
        self.text(surface,subtitle,(424,211),GOLD,self.font,True)
        if self.state=='title':
            for text,y in [('ARROWS / WASD  Fly     SPACE  Fire     B  Bomb',249),
                           ('F  Face forward / bomb     Land gently to board',274),
                           ('Open camps with weapons. Carry 16 per trip.',299)]:
                self.text(surface,text,(424,y),WHITE,self.small,True)
        self.text(surface,'ENTER TO FLY' if self.state=='title' else ('P TO RESUME' if self.paused else 'ENTER TO TRY AGAIN'),
                  (424,331),TEAL,self.font,True)


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--headless',action='store_true')
    parser.add_argument('--frames',type=int,default=0,help='Exit after this many frames (0: unlimited).')
    parser.add_argument('--screenshot',type=Path)
    args=parser.parse_args()
    if args.headless:
        os.environ['SDL_VIDEODRIVER']='dummy'
        os.environ['SDL_AUDIODRIVER']='dummy'
    pygame.display.init()
    pygame.font.init()
    screen=pygame.display.set_mode((WIDTH,HEIGHT))
    pygame.display.set_caption('Choplifter / RGB222 Rescue')
    game=Game()
    clock=pygame.time.Clock()
    running=True
    frames=0
    accumulator=0.0
    while running:
        elapsed=min(clock.tick(60)/1000,.1)
        for event in pygame.event.get():
            if event.type==pygame.QUIT:
                running=False
            elif event.type==pygame.KEYDOWN:
                if event.key==pygame.K_RETURN and game.state!='playing':
                    game.reset()
                    game.state='playing'
                elif event.key in (pygame.K_p,pygame.K_ESCAPE) and game.state=='playing':
                    game.paused=not game.paused
                elif event.key==pygame.K_f:
                    game.front=not game.front
                elif event.key==pygame.K_q:
                    running=False
        keys=pygame.key.get_pressed()
        controls=set()
        for action,bindings in {'left':(pygame.K_LEFT,pygame.K_a),'right':(pygame.K_RIGHT,pygame.K_d),
                                'up':(pygame.K_UP,pygame.K_w),'down':(pygame.K_DOWN,pygame.K_s),
                                'fire':(pygame.K_SPACE,), 'bomb':(pygame.K_b,)}.items():
            if any(keys[k] for k in bindings):
                controls.add(action)
        accumulator+=elapsed
        while accumulator>=1/120:
            game.update(1/120,controls)
            accumulator-=1/120
        game.draw(screen)
        pygame.display.flip()
        frames+=1
        if args.frames and frames>=args.frames:
            running=False
    if args.screenshot:
        pygame.image.save(screen,args.screenshot)
    pygame.quit()


if __name__=='__main__':
    main()
