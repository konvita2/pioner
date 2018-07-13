* запускается один раз

CLOSE TABLES ALL 
OPEN DATABASE db
ALTER TABLE kt ADD COLUMN kodm1 n(4)
UPDATE kt SET kodm1 = 0 
WAIT "Filed KODM1 has been added!" WINDOW 
