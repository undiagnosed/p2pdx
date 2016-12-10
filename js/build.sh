#/bin/bash

rm all.js
coffee --compile . lib/ utils/
#cat */*.js *.js > all.js

cat lib/jquery-2.2.3.min.js \
lib/bootstrap.min.js \
lib/jquery.dataTables.min.js \
lib/maquette.js \
lib/marked.min.js \
lib/Class.js \
lib/Promise.js \
lib/ZeroFrame.js \
utils/Table.js \
utils/Text.js \
utils/Time.js \
ContentDiagnoses.js \
ContentHome.js \
ContentMedications.js \
ContentSymptoms.js \
ContentTests.js \
ContentVisits.js \
ContentVitals.js \
Header.js \
P2pdx.js \
> all.js
