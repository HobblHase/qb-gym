QBCore = exports['qb-core']:GetCoreObject()

--[[ -- OLD CALLBACK's
-- --Callback de obtener las stats actuales
QBCore.Functions.CreateCallback("qb-skills:fetchStatus", function(source, cb)
     local src = source
     local Player = QBCore.Functions.GetPlayer(src)
      print('local Player = QBCore.Functions.GetPlayer(src)')
    exports.oxmysql:scalar('SELECT skills FROM players WHERE citizenid = ?', { Player.PlayerData.citizenid }, function(status)
          print('exports.oxmysql.scalar')
          print(status)
          print(type(status))
          QBCore.Debug(status)
          if status then
               cb(json.decode(status))
          else
               cb(nil)
          end
     end)
end)

--Actualizar stats
RegisterServerEvent("qb-skills:update", function(data)
     local src = source
     local Player = QBCore.Functions.GetPlayer(src)
      print(data)
      print(type(data))
      QBCore.Debug(data)
     --exports.oxmysql:execute('UPDATE players SET skills = ? WHERE citizenid = ?', {json.encode(data), Player.PlayerData.citizenid })
     exports.oxmysql:execute('UPDATE players SET skills = ? WHERE citizenid = ?', {data, Player.PlayerData.citizenid })
end) ]]

QBCore.Functions.CreateCallback("qb-skills:fetchStatus", function(source, cb)
     local src = source
     local Player = QBCore.Functions.GetPlayer(src)
 
     exports.oxmysql:scalar('SELECT * FROM player_skills WHERE citizenid = ?', { Player.PlayerData.citizenid }, function(status)
         if status then
             cb(json.decode(status))
         else
             cb(nil)
         end
     end)
 end)
 
 RegisterServerEvent("qb-skills:update", function(data)
     local src = source
     local Player = QBCore.Functions.GetPlayer(src)
     local decodedData = json.decode(data)
 
     if decodedData then
         exports.oxmysql:execute('SELECT * FROM player_skills WHERE citizenid = ?', {Player.PlayerData.citizenid}, function(result)
             if result[1] then
                 exports.oxmysql:execute('UPDATE player_skills SET driving = ?, strength = ?, diving = ?, wheelie_ability = ?, stamina = ?, shooting = ? WHERE citizenid = ?', {
                    decodedData.driving.Current or 0,
                    decodedData.strength.Current or 0,
                    decodedData.diving.Current or 0,
                    decodedData.wheelie_ability.Current or 0,
                    decodedData.stamina.Current or 0,
                    decodedData.shooting.Current or 0,
                    Player.PlayerData.citizenid
                 })
             else
                 exports.oxmysql:execute('INSERT INTO player_skills (driving, strength, diving, wheelie_ability, stamina, shooting, citizenid) VALUES (?, ?, ?, ?, ?, ?, ?)', {
                    decodedData.driving.Current or 0,
                    decodedData.strength.Current or 0,
                    decodedData.diving.Current or 0,
                    decodedData.wheelie_ability.Current or 0,
                    decodedData.stamina.Current or 0,
                    decodedData.shooting.Current or 0,
                    Player.PlayerData.citizenid
                 })
             end
         end)
     else
         QBCore.Debug("^8Error while decode... | Contact @Hobbl") -- I got some problems on my on server so I decided to put this in. I hope I fully fixxed it, if you get this print in your console pls contact me
     end
 end)


-- MAIN-FUNCTIONS

RegisterServerEvent('qb-gym:checkChip', function()
     local src = source
     local Player = QBCore.Functions.GetPlayer(src)
     local gym_membership = Player.Functions.GetItemByName('gym_membership')
 
     if gym_membership and gym_membership.amount > 0 then
         TriggerClientEvent('qb-gym:trueMembership', src)
     else
         TriggerClientEvent('qb-gym:falseMembership', src)
     end
 end)
 

RegisterServerEvent('qb-gym:buyMembership', function()
	local src = source
     local Player = QBCore.Functions.GetPlayer(src)
    
	if Player.PlayerData.money.cash >= ConfigGym.MmbershipCardPrice then
        Player.Functions.RemoveMoney('cash', ConfigGym.MmbershipCardPrice)
        Player.Functions.AddItem('gym_membership', 1)	
        TriggerClientEvent('QBCore:Notify', src, 'You successfully bought a Gym-Membership', 'success')
		TriggerClientEvent('qb-gym:trueMembership', src) -- true
	else
        TriggerClientEvent('QBCore:Notify', src, "You dont have enough cash you'll need $".. ConfigGym.MmbershipCardPrice, "error")

	end	
end)
