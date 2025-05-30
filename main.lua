local RESOLUTION_BASE_X = 800
local RESOLUTION_BASE_Y = 600
local etat = "menu" 

scale_x = love.graphics.getWidth() / RESOLUTION_BASE_X
scale_y = love.graphics.getHeight() / RESOLUTION_BASE_Y
position_terrain = -1
vitesse_balle = 2

local vitesse_pad = 3 * scale_y

pad = {}
pad.x = 0
pad.y = 0
pad.largeur = 20 * scale_x
pad.hauteur = 80 * scale_y

pad2 = {}
pad2.x = 0
pad2.y = 0
pad2.largeur = 20 * scale_x
pad2.hauteur = 80 * scale_y

balle = {}
balle.x = 400
balle.y = 300
balle.largeur = 20 * scale_x
balle.hauteur = 20 * scale_y
balle.vitesse_x = vitesse_balle * scale_x
balle.vitesse_y = vitesse_balle * scale_y

score_joueur1 = 0
score_joueur2 = 0
score_max     = 5

listeTrail = {}

local fonctions = require("fonctions/function")

function love.load()
  
  love.window.setTitle("DYNAMITE PONG")  -- Définit le titre de la fenêtre
  
  position_terrain = fonctions.getRandomDirection()
  fonctions.CentreBalle(position_terrain)
  
  local Font = love.graphics.newFont("assets/fonts/square-deal.ttf", 60)
  love.graphics.setFont(Font)
  
  sndMenu = love.audio.newSource("assets/sons/menu.wav", "static")
  sndMur = love.audio.newSource("assets/sons/mur.wav", "static")
  sndPerdu = love.audio.newSource("assets/sons/perdu.wav", "static")
  
end

function love.update(dt) 
  if etat == "jeu" then
    --pad de gauche
    if love.keyboard.isDown("q") and pad.y + pad.hauteur < love.graphics.getHeight() then
      pad.y = pad.y + vitesse_pad
    end
    if love.keyboard.isDown("a") and pad.y >= 0 then
      pad.y = pad.y - vitesse_pad
    end
    
    --pad de droite
    if love.keyboard.isDown("down") and pad2.y + pad2.hauteur < love.graphics.getHeight() then
      pad2.y = pad2.y + vitesse_pad
    end
    if love.keyboard.isDown("up") and pad2.y >= 0 then
      pad2.y = pad2.y - vitesse_pad
    end
    
    for n=#listeTrail,1,-1 do
      local t = listeTrail[n]
      t.vie = t.vie - dt  
      --t.x = t.x + t.vx
      --t.y = t.y + t.vy
      if t.vie <= 0 then
        table.remove(listeTrail, n)
      end
    end
    
    local maTrainee = {}
    maTrainee.x = balle.x
    maTrainee.y = balle.y
    --maTrainee.vx = math.random(-1,1)
   -- maTrainee.vy = math.random(-1,1)
    maTrainee.vie = 0.5
    --maTrainee.r  = math.random()
    --maTrainee.v   = math.random()
    --maTrainee.b   = math.random()
    table.insert(listeTrail, maTrainee)
    
    balle.x = balle.x + balle.vitesse_x
    balle.y = balle.y + balle.vitesse_y
    
    -- rebond sur les murs
    if balle.x < 0 then
      balle.vitesse_x = balle.vitesse_x * -1
    end
    if balle.y < 0 then
      balle.vitesse_y = balle.vitesse_y * -1
      love.audio.play(sndMur)
    end
    if balle.y > love.graphics.getHeight() - balle.hauteur then
      balle.vitesse_y = balle.vitesse_y * -1 
      love.audio.play(sndMur)
    end
    
    -- La balle a-t-elle atteint le bord gauche de l'écran
    if balle.x <= 0 then
      -- Perdu joueur 1!      
      score_joueur2 = score_joueur2 + 1
      love.audio.play(sndPerdu)
      if score_joueur1 == score_max then
        etat = "menu" -- Retour au menu
      else
        fonctions.CentreBalle(-1)
      end
    end
    
    -- La balle a-t-elle atteint la raquette de gauche ?
    if balle.x <= pad.x + pad.largeur then
      -- Tester maintenant si la balle est sur la raquette ou pas
      if balle.y + balle.hauteur > pad.y and balle.y < pad.y + pad.hauteur then
        balle.vitesse_x = balle.vitesse_x * -1
        -- Positionne la balle au bord de la raquette
        balle.x = pad.x + pad.largeur
        love.audio.play(sndMur)
      end
    end
   
     -- La balle a-t-elle atteint la raquette de droite ?
    if balle.x + balle.largeur >= pad2.x then
        -- Tester maintenant si la balle est sur la raquette ou pas
        if balle.y + balle.hauteur > pad2.y and balle.y < pad2.y + pad2.hauteur then
          balle.vitesse_x = balle.vitesse_x * -1  -- Inverser la direction
          -- Positionner la balle au bord de la raquette
          balle.x = pad2.x - balle.largeur
          love.audio.play(sndMur)
        end
    end
    
    -- La balle a-t-elle atteint le bord droit de l'écran
    if balle.x > love.graphics.getWidth() - balle.largeur then
      -- Perdu joueur 2!          
      score_joueur1 = score_joueur1 + 1
      love.audio.play(sndPerdu)
      if score_joueur1 == score_max then
        etat = "menu" -- Retour au menu
      else
        fonctions.CentreBalle(1)
      end
    end
    
  end
end

function love.draw()
  if etat == "menu" then
    love.audio.play(sndMenu)
    love.graphics.setFont(love.graphics.newFont(40))
    love.graphics.printf("DYNAMITE PONG", 0, 100, love.graphics.getWidth(), "center")
    love.graphics.printf("Appuie sur ESPACE pour jouer", 0, 200, love.graphics.getWidth(), "center")
    love.graphics.printf("Appuie sur ECHAP pour quitter", 0, 300, love.graphics.getWidth(), "center")
  else
    -- Dessin des pads
    love.graphics.rectangle("fill", pad.x, pad.y, pad.largeur, pad.hauteur)
    love.graphics.rectangle("fill", pad2.x, pad2.y, pad2.largeur, pad2.hauteur)
    
    -- Dessin de la trainée
    for n=1,#listeTrail do
      local t = listeTrail[n]
      local alpha = t.vie / 2
      love.graphics.setColor(1,1,1,alpha)
      -- bleu   
      --love.graphics.setColor(t.r,t.v,t.b,alpha)
      
      --balle fantôme
      love.graphics.rectangle("fill", t.x, t.y, balle.largeur, balle.hauteur)
      
      --bulles
      --love.graphics.circle("line", t.x + balle.largeur / 2 , t.y + balle.hauteur / 2, 5)
      --balle fantôme 2
      --love.graphics.rectangle("line", t.x, t.y, balle.largeur, balle.hauteur)
    end
    
    -- Dessin de la balle
    love.graphics.setColor(1,1,1,1)
    love.graphics.rectangle("fill", balle.x, balle.y, balle.largeur, balle.hauteur)
    
    
    love.graphics.setLineWidth( 4 )
    love.graphics.line(love.graphics.getWidth() / 2, 0, love.graphics.getWidth() / 2, love.graphics.getHeight())
    
    -- Affiche le score centré sur l'écran
    local font = love.graphics.getFont()
    local score = score_joueur1.."   "..score_joueur2
    local largeur_score = font:getWidth(score)
    love.graphics.print(score, (love.graphics.getWidth() / 2) - (largeur_score / 2), 5)
  end
  
end

function love.keypressed(key)
    if etat == "menu" and key == "space" then
        etat = "jeu"  -- Lancer le jeu
        fonctions.CentreBalle(fonctions.getRandomDirection())  -- Initialisation de la balle
    elseif key == "escape" then
        love.event.quit()  -- Quitter le jeu
    end
end