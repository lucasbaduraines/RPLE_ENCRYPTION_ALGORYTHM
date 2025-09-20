function gcd(a, b)
  while b ~= 0 do
    a, b = b, a % b
    --b = a % b
  end
  return a
end


function modInverse(e, phi)
  for d = 2, phi do
    if (e * d) % phi == 1 then
      return d
    end
  end
  return -1
end

function isPrime(n)
    if n < 2 then return false end -- Numbers less than 2 are not prime
    if n == 2 then return true end -- 2 is the only even prime
    if n % 2 == 0 then return false end -- Other even numbers are not prime

    -- Check for odd divisors up to the square root of n
    for i = 3, math.sqrt(n), 2 do
        if n % i == 0 then
            return false
        end
    end
    return true
end

function generateRandomPrime(min, max)
    math.randomseed(os.time()) -- Seed the random number generator

    while true do
        local candidate = math.random(min, max)
        if isPrime(candidate) then
            return candidate
        end
    end
end


function generateKeys()
  local p = 7919
  local q = generateRandomPrime(1000,5000)
  


  local n = p * q
  local phi = (p - 1) * (q - 1)

  local e = 0
  for i = 1000, phi do
    if gcd(i, phi) == 1 then
      e = i
      break
    end
  end

  local d = modInverse(e, phi)


  return e, d, n


end


--local bit = require("bit")




function power(base, expo, m)
  local res = 1
  base = base % m
  while expo > 0 do
    if expo % 2 == 1 then
      res = (res * base) % m
    end
    base = (base * base) % m
    expo = math.floor(expo / 2)
  end
  return res
end


function encrypt(m, e, n)
  return power(m, e, n)
end


function decrypt(c, d, n)
  return power(c, d, n)
end


-- bellow this will be the encryption of the message itself, something symetric, the symetric key will be encrypted with RSA.
--uhh generate new symetric key every convo


function generateSymetricalKeys()
  --make this thing at the bottom be the demands latr
  local demands = "fart"
  return ("" .. string.byte(demands) * math.random(#demands))
end


function xor_no_bit_funcs(a, b)
  local result = 0
  local power_of_2 = 1


  while a > 0 or b > 0 do
    local bit_a = a % 2
    local bit_b = b % 2


    -- XOR logic: if bits are different, the result bit is 1
    if (bit_a ~= bit_b) then
      result = result + power_of_2
    end


    a = math.floor(a / 2)
    b = math.floor(b / 2)
    power_of_2 = power_of_2 * 2
  end


  return result
end


function xor_cipher(message, key)
  local encrypted_chars = {}
  for i = 1, #message do
    local char_code = string.byte(message, i)
    local key_char_code = string.byte(key, (i - 1) % #key + 1)
    local xored_code = xor_no_bit_funcs(char_code, key_char_code)
    table.insert(encrypted_chars, xored_code)
  end
  return string.char(unpack(encrypted_chars))
end




RSA_privateKey, RSA_publicKey, RSA_lock = generateKeys()



plaintextXorKey = generateSymetricalKeys()
local encryptedMsg = xor_cipher("hello!!!!!", plaintextXorKey)


encryptedXorKey = encrypt(plaintextXorKey, RSA_publicKey, RSA_lock)
decryptedXorKey = decrypt(encryptedXorKey, RSA_privateKey, RSA_lock)
local decryptedText = xor_cipher(encryptedMsg, tostring(decryptedXorKey))

print("P1's original message: hello!!!!!")
print("message XOR key: " .. plaintextXorKey)
print("encrypted message: " .. encryptedMsg)
print("P2's RSA_public Key: " .. RSA_publicKey)
print("P2's RSA_lock: " .. RSA_lock)

print("P1's encrypted XOR key: " .. encryptedXorKey)

print("------SENT TO P2 --------")

print("P2's RSA_private Key: " .. RSA_privateKey)
print("P2's RSA_public Key: " .. RSA_publicKey)
print("P2's RSA_lock: " .. RSA_lock)

print("P1's encrypted XOR key: " .. encryptedXorKey)
print("encrypted message: " .. encryptedMsg)

print("DECRYPTED MESSAGE: " .. decryptedText)






--this was all for a graphics thing i was doing in love2d
--however i ran out of time like its 11:30 pm and its due in 30
--minutes imma js sumbit the algorythm


-- --this is sent once you add the person to your contacts
-- --sends your public key to them so they can send u stuff
-- --safely!!!!!!!!
-- local KeyPayload = {
--   RSA_publicKey,
--   RSA_lock
-- }




-- local messagePayload = {
--   encryptedMsg,
--   encryptedXorKey
-- }

-- RSA_privateKey, RSA_publicKey, RSA_lock = generateKeys()


-- local currentInputBox = ""

-- local inputText = ""

-- local messageKey = ""
-- local encryptedInputText = ""


-- local othersRSA_publicKey = ""
-- local otherRSA_lock = ""

-- function encryptMessage()
--     local XOR_key = generateSymetricalKeys()
--     messageKey = encrypt(XOR_key, othersRSA_publicKey, otherRSA_lock)
--     encryptedInputText = xor_cipher(inputText, XOR_key)
-- end

-- function love.load()

--     love.window.setMode(400, 400)

--     love.keyboard.setKeyRepeat(true)
-- end

-- function love.textinput(key)
--     inputText = inputText .. key
-- end

-- function love.keypressed(key)
--     if key == "backspace" then
--         inputText = inputText:sub(1, -2)
--         local utf8 = require("utf8")
--         local byteoffset = utf8.offset(inputText, -1)
--         if byteoffset then
--             inputText = string.sub(inputText, 1, byteoffset - 1)
--         end
--     end

-- end

-- function love.mousepressed(x, y, button, isTouch)
--     if button == 1 then
--         --messageInput is pressed
--         if x < 350 and x > 50 and y < 70 and y > 50 then
--             currentInputBox = inputText
--         end

--         --if the encrypt button is pressed
--         if x < 130 and x > 30 and y < 350 and y > 300 then
--             encryptMessage()
--         end
--     end
-- end




-- function love.draw()
--     --RSA data
    
--     love.graphics.print("private key: " .. RSA_privateKey, 0, 0)
--     love.graphics.print("public key: " .. RSA_publicKey, 0, 15)
--     love.graphics.print("lock: " .. RSA_lock,0 ,30)

--     --text input
--     love.graphics.setColor(0.3, 0.3, 0.3, 1)
--     love.graphics.rectangle("fill", 50, 50, 300, 20)

--     love.graphics.setColor(1, 1, 1, 1)
--     love.graphics.rectangle("line", 50, 50, 300, 20)

--     love.graphics.print(inputText, 55, 52)

--     love.graphics.print("encrypted message: " .. encryptedInputText, 50, 70)
--     love.graphics.print("message key: " .. encryptedInputText, 50, 90)


--     --input others key and lock

--     --key
--     love.graphics.setColor(0.4, 0.4, 0.4, 1)
--     love.graphics.rectangle("fill", 50, 120, 150, 20)
--     love.graphics.setColor(1, 1, 1, 1)
--     love.graphics.rectangle("line", 50, 120, 150, 20)

--     love.graphics.print(othersRSA_publicKey, 55, 52)

--     --encrypt btn

--     love.graphics.setColor(0.3, 0, 0, 1)
--     love.graphics.rectangle("fill", 30, 300, 100, 50)

--     love.graphics.setColor(1, 1, 1, 1)
--     love.graphics.rectangle("line", 30, 300, 100, 50)

--     love.graphics.print("encrypt", 40, 325)

--     --decrypt btn

--     love.graphics.setColor(0.3, 0, 0, 1)
--     love.graphics.rectangle("fill", 230, 300, 100, 50)

--     love.graphics.setColor(1, 1, 1, 1)
--     love.graphics.rectangle("line", 230, 300, 100, 50)

--     love.graphics.print("decrypt", 240, 325)

-- end





