#!/bin/sh

# Eleva os limites de consumo elétrico (STAPM / PPT) mantendo a temperatura segura
sudo ryzenadj --stapm-limit=20000 --fast-limit=23500 --slow-limit=19000 --tctl-temp=85
# Verificando se aplicou
sudo ryzenadj -i | grep -E "STAPM|LIMIT|Slow|Fast"
