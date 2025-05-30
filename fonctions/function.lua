local fonctions = {}

function fonctions.getRandomDirection()
  local direction = math.random(0, 1) == 0 and -1 or 1
  return direction
end

function fonctions.CentreBalle(position_terrain) 
  
  pad.x = 0
  pad.y = (love.graphics.getHeight() - pad.hauteur) / 2

  pad2.x = love.graphics.getWidth() - pad2.largeur
  pad2.y = (love.graphics.getHeight() - pad2.hauteur) / 2
  
  balle.x = love.graphics.getWidth() / 2
  balle.x = balle.x - balle.largeur / 2
  balle.y = love.graphics.getHeight() / 2
  balle.y = balle.y - balle.hauteur / 2
  balle.vitesse_x = position_terrain * math.random(vitesse_balle) * scale_x -- *-1 repart vers raquette de gauche
  balle.vitesse_y = math.random(vitesse_balle) * scale_y
  
  listeTrail = {}
end

return fonctions