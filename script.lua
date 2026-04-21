print("✅ Скрипт загружен успешно!")

-- создаём Part в игре
local part = Instance.new("Part")
part.Size = Vector3.new(5, 1, 5)
part.Position = Vector3.new(0, 10, 0)
part.Anchored = true
part.BrickColor = BrickColor.new("Bright green")
part.Parent = workspace

print("🟢 Парт создан!")
