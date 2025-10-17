// Estado global
let gameState = {
  aura: 25,
  money: 100,
  infiniteMoney: false,
  barricadeStrength: 0,
  evidence: 0,
  reputation: 50
};

// Farmear aura
function farmAura(action) {
  const gains = { speech: 10, evidenceSubmit: 15, viral: 20, helpNeighbor: 8 };
  let gain = gains[action] || 0;
  // small RNG depending on reputation
  gain = Math.max(0, Math.floor(gain * (1 + gameState.reputation/200)));
  gameState.aura += gain;
  return gain;
}

// Dinero ilimitado toggle
function setInfiniteMoney(on) {
  gameState.infiniteMoney = on;
}
function adjustMoney(amount) {
  if(gameState.infiniteMoney) return; // no cambia
  gameState.money += amount;
}

// Reforzar barricada
function reinforceBarricade(cost) {
  if(gameState.infiniteMoney || gameState.money >= cost) {
    if(!gameState.infiniteMoney) gameState.money -= cost;
    gameState.barricadeStrength += Math.floor(cost/10);
    return true;
  }
  return false;
}

// Auto-list generator (útil para dialogar con la inspectora)
function autoListGenerator() {
  // consume small aura but produce formal list
  if(gameState.aura >= 5) {
    gameState.aura -= 5;
    return { success: true, list: ["Mateo","Lina","Don Álvaro"], credibility: 70 + gameState.reputation/2 };
  }
  return { success:false, reason:"Baja aura" };
}
