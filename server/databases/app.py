from milli_emlak import gun, saat
import time
zaman = 24

while True:
    print("Bekleniyor...")
    gun()
    saat()
    time.sleep(zaman * 60 * 60) 
