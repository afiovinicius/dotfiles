#!/bin/sh

# Eleva os limites de consumo elétrico (STAPM / PPT) mantendo a temperatura segura
sudo ryzenadj --stapm-limit=22000 --fast-limit=25000 --slow-limit=22000 --tctl-temp=85
# Verificando se aplicou
sudo ryzenadj -i | grep -E "STAPM|LIMIT|Slow|Fast"
