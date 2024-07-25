-- Add 2 missing linkage tables
CREATE TABLE building_in_city AS
SELECT DISTINCT ON (t1.gid) t1.gid AS b_gid, t2.gid AS loc_gid
    FROM "sie05_p" t1
    INNER JOIN "sie01_f" t2 ON st_within(t1.geom, t2.geom);

ALTER TABLE building_in_city ADD PRIMARY KEY (b_gid);


CREATE TABLE wbcourse_in_loc AS
SELECT DISTINCT ON (t1.gid) t1.gid AS w_gid, t2.gid AS loc_gid
    FROM "gew01_f" t1
    INNER JOIN "sie01_f" t2 ON st_intersects(t1.geom, t2.geom);

ALTER TABLE wbcourse_in_loc ADD PRIMARY KEY (w_gid);


-- Some attributes in the RoadTraffic table contain -9998 instead of NULL values
UPDATE ver01_l
SET brf = CASE
          WHEN brf = -9998 THEN NULL
          ELSE brf
END;

UPDATE ver01_l
SET fsz = CASE
          WHEN fsz = -9998 THEN NULL
          ELSE fsz
END;

UPDATE ver06_l
SET bro = CASE
              WHEN bro = -9999 THEN NULL
              ELSE bro
    END;

UPDATE ver06_p
SET bro = CASE
              WHEN bro = -9999 THEN NULL
              ELSE bro
    END;


-- Source: https://www.adv-online.de/GeoInfoDok/Aktuelle-Anwendungsschemata/AAA-Anwendungsschema-7.1.2-Referenz-7.1/binarywriterservlet?imgUid=78f7a5be-17ae-4819-393b-216067bef8a0&uBasVariant=11111111-1111-1111-1111-111111111111#_C11007-_A11007_46283
-- FROM: https://www.adv-online.de/GeoInfoDok/Aktuelle-Anwendungsschemata/AAA-Anwendungsschema-7.1.2-Referenz-7.1/, OK AAA-Anwendungsschema 7.1.2 (HTML)
-- VERSION 7.1.2 needed for this dataset
-- Add tables which map respective attribute codes to their names in German and their respective English translation
-- English translation is performed via Deepl
-- Attribute: gebaeudefunktion

CREATE TABLE gebaeudefunktion (
    code VARCHAR(4) PRIMARY KEY,
    name_en TEXT,
    name_de TEXT,
    definition_de TEXT,
    CONSTRAINT check_column_format CHECK (
        code ~ '^[0-9]{4}$'
        AND LENGTH(code) = 4 )
    );

INSERT INTO gebaeudefunktion VALUES (1000, 'Residential building', '''Wohngebäude'' ist ein Gebäude, das zum Wohnen genutzt wird.');
INSERT INTO gebaeudefunktion VALUES (1010, 'Residential house', 'Wohnhaus', '''Wohnhaus'' ist ein Gebäude, in dem Menschen ihren Wohnsitz haben.');
INSERT INTO gebaeudefunktion VALUES (1020, 'Dormitory', 'Wohnheim', '''Wohnheim'' ist ein Gebäude, das nach seiner baulichen Anlage und Ausstattung zur Unterbringung von Studenten, Arbeitern u. a. bestimmt ist.');
INSERT INTO gebaeudefunktion VALUES (1021, 'Children''s home', 'Kinderheim', '''Kinderheim'' ist ein Gebäude, welches zur Unterbringung und Betreuung von Kindern, die vorübergehend oder dauerhaft getrennt von ihren leiblichen Eltern oder sonstigen Erziehungsberechtigten leben, dient.');
INSERT INTO gebaeudefunktion VALUES (1022, 'Retirement home', 'Seniorenheim', '''Seniorenheim'' ist ein Gebäude, welches zur Unterbringung, Betreuung und Pflege von Menschen dient.');
INSERT INTO gebaeudefunktion VALUES (1023, 'Nurses'' residence', 'Schwesternwohnheim', '''Schwesternwohnheim'' ist ein Gebäude, in dem Angehörige eines Ordens oder Pflegepersonal wohnen.');
INSERT INTO gebaeudefunktion VALUES (1024, 'Student and school dormitory', 'Studenten-, Schülerwohnheim', '''Studenten-, Schülerwohnheim'' ist ein Gebäude, in welchem Studenten bzw. Schüler wohnen.');
INSERT INTO gebaeudefunktion VALUES (1025, 'School hostel', 'Schullandheim', '''Schullandheim'' ist ein Gebäude in ländlicher Region, in dem sich Schulklassen jeweils für einige Tage zur Erholung und zum Unterricht aufhalten.');
INSERT INTO gebaeudefunktion VALUES (1100, 'Mixed-use building with residential housing', 'Gemischt genutztes Gebäude mit Wohnen', '''Gemischt genutztes Gebäude mit Wohnen'' ist ein Gebäude, in dem sowohl gewohnt wird, als auch Teile des Gebäudes zum Anbieten von Dienstleistungen, zur Durchführung von öffentlichen oder privaten Verwaltungsarbeiten, zur gewerblichen oder industriellen Tätigkeit genutzt werden.');
INSERT INTO gebaeudefunktion VALUES (1110, 'Residential building with public use', 'Wohngebäude mit Gemeinbedarf', '''Wohngebäude mit Gemeinbedarf'' ist ein Gebäude, das vorrangig dem Wohnen als auch der Allgemeinheit, z. B. zur Versammlung, dient.');
INSERT INTO gebaeudefunktion VALUES (1120, 'Residential building with retail and services', 'Wohngebäude mit Handel und Dienstleistungen', '''Wohngebäude mit Handel und Dienstleistungen'' ist ein Gebäude, das vorrangig dem Wohnen als auch dem Anbieten von Arbeitsleistungen, die nicht im Zusammenhang mit der Produktion von materiellen Gütern stehen, dient.');
INSERT INTO gebaeudefunktion VALUES (1121, 'Residential and administration building', 'Wohn- und Verwaltungsgebäude', '''Wohn- und Verwaltungsgebäude'' ist ein Gebäude, in dem gewohnt wird und in dem sich Räume einer öffentlichen oder privaten Verwaltung befinden.');
INSERT INTO gebaeudefunktion VALUES (1122, 'Residential and office building', 'Wohn- und Bürogebäude', '''Wohn- und Bürogebäude'' ist ein Gebäude, in dem gewohnt wird und in dem sich Büros mehrerer Unternehmen befinden.');
INSERT INTO gebaeudefunktion VALUES (1123, 'Residential and commercial building', 'Wohn- und Geschäftsgebäude', '''Wohn- und Geschäftsgebäude'' ist ein Gebäude, in dem gewohnt wird und in dem sich ein oder mehrere Geschäfte befinden, in denen Waren zum Verkauf angeboten werden.');
INSERT INTO gebaeudefunktion VALUES (1130, 'Residential building with trade and industry', 'Wohngebäude mit Gewerbe und Industrie', '''Wohngebäude mit Gewerbe und Industrie'' ist ein Gebäude, das vorrangig dem Wohnen und dem Anbieten von gewerblichen oder industriellen Tätigkeiten dient.');
INSERT INTO gebaeudefunktion VALUES (1131, 'Residential and industrial building', 'Wohn- und Betriebsgebäude', '''Wohn- und Betriebsgebäude'' ist ein Gebäude, das sowohl zum Wohnen als auch zur Produktion von Gütern dient.');
INSERT INTO gebaeudefunktion VALUES (1210, 'Agricultural and forestry residential building', 'Land- und forstwirtschaftliches Wohngebäude', '''Land- und forstwirtschaftliches Wohngebäude'' ist ein Gebäude, in dem Beschäftigte der Land- und Forstwirtschaft wohnen.');
INSERT INTO gebaeudefunktion VALUES (1220, 'Agricultural and forestry residential and commercial building', 'Land- und forstwirtschaftliches Wohn- und Betriebsgebäude', '''Land- und forstwirtschaftliches Wohn- und Betriebsgebäude'' ist ein Gebäude, das zum Wohnen und zur Produktion von land- und forstwirtschaftlichen Gütern dient.');
INSERT INTO gebaeudefunktion VALUES (1221, 'Farmhouse', 'Bauernhaus', '''Bauernhaus'' ist das Wohn- und Betriebsgebäude eines Landwirts.');
INSERT INTO gebaeudefunktion VALUES (1222, 'Residential and farm building', 'Wohn- und Wirtschaftsgebäude', '''Wohn- und Wirtschaftsgebäude'' ist ein Gebäude, in dem gewohnt wird und das zum Betrieb eines wirtschaftlichen Anwesens notwendig ist.');
INSERT INTO gebaeudefunktion VALUES (1223, 'Forester''s lodge', 'Forsthaus', '''Forsthaus'' ist ein Gebäude, das gleichzeitig Wohnhaus und Dienststelle der Försterin oder des Försters ist.');
INSERT INTO gebaeudefunktion VALUES (1310, 'Building for leisure activities', 'Gebäude zur Freizeitgestaltung', '''Gebäude zur Freizeitgestaltung'' ist ein Gebäude, das der Ausübung von freizeitlichen Aktivitäten dient.');
INSERT INTO gebaeudefunktion VALUES (1311, 'Holiday home', 'Ferienhaus', '''Ferienhaus'' ist ein Gebäude, das zum vorübergehenden Aufenthalt von Gästen dient.');
INSERT INTO gebaeudefunktion VALUES (1312, 'Weekend house', 'Wochenendhaus', '''Wochenendhaus'' ist ein Gebäude, in dem dauerhaftes Wohnen möglich, aber nicht gestattet ist. Es dient nur zum zeitlich begrenzten Aufenthalt in der Freizeit, beispielsweise am Wochenende oder im Urlaub und steht i. d. R. in einem besonders dafür ausgewiesenen Gebiet (Wochenendhausgebiet).');
INSERT INTO gebaeudefunktion VALUES (1313, 'Garden shed', 'Gartenhaus', '''Gartenhaus'' ist ein eingeschossiges Gebäude in einfacher Ausführung und dient hauptsächlich der Unterbringung von Gartengeräten.');
INSERT INTO gebaeudefunktion VALUES (2000, 'Buildings for business or trade', 'Gebäude für Wirtschaft oder Gewerbe', '''Gebäude für Wirtschaft oder Gewerbe'' ist ein Gebäude, das der Produktion von Waren, der Verteilung von Gütern und dem Angebot von Dienstleistungen dient.');
INSERT INTO gebaeudefunktion VALUES (2010, 'Buildings for trade and services', 'Gebäude für Handel und Dienstleistungen', '''Gebäude für Handel und Dienstleistungen'' ist ein Gebäude, in dem Arbeitsleistungen, die nicht der Produktion von materiellen Gütern dienen, angeboten werden. Dazu gehört u. a. der Handel (Ankauf, Transport, Verkauf) mit Gütern, Kapital oder Wissen.');
INSERT INTO gebaeudefunktion VALUES (2020, 'Office building', 'Bürogebäude', '''Bürogebäude'' ist ein Gebäude, in dem private Wirtschaftunternehmen ihre Verwaltungsarbeit durchführen.');
INSERT INTO gebaeudefunktion VALUES (2030, 'Credit institution', 'Kreditinstitut', '''Kreditinstitut'' ist ein Gebäude, in dem Unternehmen gewerbsmäßig Geldgeschäfte (Verwaltung von Ersparnissen, Vergabe von Krediten) betreiben, die einen kaufmännisch eingerichteten Geschäftsbetrieb erfordern.');
INSERT INTO gebaeudefunktion VALUES (2040, 'Insurance', 'Versicherung', '''Versicherung'' ist ein Gebäude, in dem Versicherungsunternehmen gewerbsmäßige Versicherungsgeschäfte betreiben.');
INSERT INTO gebaeudefunktion VALUES (2050, 'Commercial building', 'Geschäftsgebäude', '''Geschäftsgebäude'' ist ein Gebäude, in dem Ein- und Verkauf von Waren stattfindet.');
INSERT INTO gebaeudefunktion VALUES (2051, 'Department store', 'Kaufhaus', '''Kaufhaus'' ist ein Gebäude, meist mit mehreren Stockwerken, in dem breite Warensortimente zum Kauf angeboten werden.');
INSERT INTO gebaeudefunktion VALUES (2052, 'Shopping centre', 'Einkaufszentrum', '''Einkaufszentrum'' ist ein Gebäude oder Gebäudekomplex, in dem mehrere Geschäfte untergebracht sind.');
INSERT INTO gebaeudefunktion VALUES (2053, 'Indoor market', 'Markthalle', '''Markthalle'' ist ein Gebäude, in dem Marktstände fest oder vorübergehend aufgebaut sind.');
INSERT INTO gebaeudefunktion VALUES (2054, 'Shop', 'Laden', '''Laden'' ist ein Geschäft, in dem Waren des Einzelhandels angeboten und verkauft werden.');
INSERT INTO gebaeudefunktion VALUES (2055, 'Kiosk', 'Kiosk', '''Kiosk'' ist ein kleines in meist leichter Bauweise errichtetes Gebäude, das als Verkaufseinrichtung für ein beschränktes Warenangebot dient.');
INSERT INTO gebaeudefunktion VALUES (2056, 'Pharmacy', 'Apotheke', '''Apotheke'' ist ein Geschäft, in dem Arzneimittel hergestellt und verkauft werden.');
INSERT INTO gebaeudefunktion VALUES (2060, 'Exhibition hall', 'Messehalle', '''Messehalle'' ist ein Gebäude, das zur Ausstellung von Kunstgegenständen oder Wirtschaftsgütern dient.');
INSERT INTO gebaeudefunktion VALUES (2070, 'Building for accommodation', 'Gebäude für Beherbergung', '''Gebäude für Beherbergung'' ist ein Gebäude, das der Unterbringung von Gästen dient.');
INSERT INTO gebaeudefunktion VALUES (2071, 'Hotel, Motel, Guesthouse', 'Hotel, Motel, Pension', '''Hotel, Motel, Pension'' ist ein Gebäude mit Beherbergungs- und/oder Verpflegungsbetrieb nach Service, Ausstattung und Qualität in verschiedene Kategorien eingeteilt. Das Motel ist besonders eingerichtet für Reisende mit Kraftfahrzeug an verkehrsreichen Straßen.');
INSERT INTO gebaeudefunktion VALUES (2072, 'Youth Hostel', 'Jugendherberge', '''Jugendherberge'' ist eine zur Förderung von Jugendreisen dienende Aufenthalts- und Übernachtungsstätte.');
INSERT INTO gebaeudefunktion VALUES (2073, 'Cabin (with overnight accommodation)', 'Hütte (mit Übernachtungsmöglichkeit)', '''Hütte (mit Übernachtungsmöglichkeit)'' ist ein Gebäude außerhalb von Ortschaften, meist in den Bergen, in dem Menschen übernachten und Schutz suchen können.');
INSERT INTO gebaeudefunktion VALUES (2074, 'Campsite building', 'Campingplatzgebäude', '''Campingplatzgebäude'' ist ein Gebäude auf einem angelegten Platz, z. B. mit Strom- und Wasseranschlüssen sowie sanitären Einrichtungen.');
INSERT INTO gebaeudefunktion VALUES (2080, 'Catering building', 'Gebäude für Bewirtung', '''Gebäude für Bewirtung'' ist ein Gebäude, in dem die Möglichkeit besteht Mahlzeiten und Getränke einzunehmen.');
INSERT INTO gebaeudefunktion VALUES (2081, 'Restaurant, pub', 'Gaststätte, Restaurant', '''Gaststätte, Restaurant'' ist ein Gebäude, in dem gegen Entgelt Mahlzeiten und Getränke zum Verzehr angeboten werden.');
INSERT INTO gebaeudefunktion VALUES (2082, 'Cabin (without overnight accommodation)', 'Hütte (ohne Übernachtungsmöglichkeit)', '''Hütte (ohne Übernachtungsmöglichkeit)'' ist ein Gebäude außerhalb von Ortschaften, meist in den Bergen, in dem Menschen Schutz suchen können und in dem die Möglichkeit besteht, Mahlzeiten und Getränke einzunehmen.');
INSERT INTO gebaeudefunktion VALUES (2083, 'Canteen', 'Kantine', '''Kantine'' ist ein Gebäude, das einem Unternehmen, einer Behörde oder einer öffentlichen Einrichtung zur Ausgabe von Mahlzeiten und Getränken dient.');
INSERT INTO gebaeudefunktion VALUES (2090, 'Leisure and amusement centre', 'Freizeit- und Vergnügungsstätte', '''Freizeit- und Vergnügungsstätte'' ist ein Gebäude, in dem man in seiner Freizeit bestimmte Angebote wahrnehmen kann.');
INSERT INTO gebaeudefunktion VALUES (2091, 'Ballroom', 'Festsaal', '''Festsaal'' ist ein Gebäude, in dem Feierlichkeiten ausgerichtet werden.');
INSERT INTO gebaeudefunktion VALUES (2092, 'Cinema', 'Kino', '''Kino'' ist ein Gebäude, in dem Filme für ein Publikum abgespielt werden.');
INSERT INTO gebaeudefunktion VALUES (2093, 'Bowling hall', 'Kegel-, Bowlinghalle', '''Kegel-, Bowlinghalle'' ist ein Gebäude, in dem die Sportarten Kegeln oder Bowling ausgeübt werden.');
INSERT INTO gebaeudefunktion VALUES (2094, 'Casino', 'Spielkasino', '''Spielkasino'' ist eine Einrichtung, in der öffentlich zugänglich staatlich konzessioniertes Glücksspiel betrieben wird.');
INSERT INTO gebaeudefunktion VALUES (2095, 'Arcade', 'Spielhalle', '''Spielhalle'' ist eine Einrichtung, in der durch die Spielverordnung geregeltes Automatenspiel betrieben wird.');
INSERT INTO gebaeudefunktion VALUES (2100, 'Buildings for trade and industry', 'Gebäude für Gewerbe und Industrie', '''Gebäude für Gewerbe und Industrie'' ist ein Gebäude, dass vorwiegend gewerblichen oder industriellen Zwecken dient.');
INSERT INTO gebaeudefunktion VALUES (2110, 'Production building', 'Produktionsgebäude', '''Produktionsgebäude'' ist ein Gebäude, das zur Herstellung von Wirtschaftsgütern dient.');
INSERT INTO gebaeudefunktion VALUES (2111, 'Factory', 'Fabrik', '''Fabrik'' ist ein Gebäude mit technischen Anlagen zur Herstellung von Waren in großen Mengen.');
INSERT INTO gebaeudefunktion VALUES (2112, 'Company building', 'Betriebsgebäude', '''Betriebsgebäude'' ist ein Gebäude, in dem Arbeitskräfte und Produktionsmittel zusammengefasst sind, um Leistungen zu erbringen oder Güter herzustellen.');
INSERT INTO gebaeudefunktion VALUES (2113, 'Brewery', 'Brauerei', '''Brauerei'' ist ein Gebäude, in dem Getränke durch Gärung hergestellt werden.');
INSERT INTO gebaeudefunktion VALUES (2114, 'Distillery', 'Brennerei', '''Brennerei'' ist ein Gebäude, in dem alkoholische Getränke durch Destillation hergestellt werden.');
INSERT INTO gebaeudefunktion VALUES (2120, 'Workshop', 'Werkstatt', '''Werkstatt'' ist ein Gebäude, in dem mit Werkzeugen und Maschinen Güter hergestellt oder repariert werden.');
INSERT INTO gebaeudefunktion VALUES (2121, 'Sawmill', 'Sägewerk', '''Sägewerk'' ist ein Gebäude, in dem Holz zugeschnitten wird.');
INSERT INTO gebaeudefunktion VALUES (2130, 'Petrol station', 'Tankstelle', '''Tankstelle'' ist ein Gebäude, in dem hauptsächlich Kfz-Kraftstoffe, Schmiermittel und Zubehör verkauft werden, meist mit Einrichtungen zur Durchführung von Wartungs- und Pflegearbeiten von Kraftfahrzeugen.');
INSERT INTO gebaeudefunktion VALUES (2131, 'Car wash', 'Waschstraße, Waschanlage, Waschhalle', '''Waschstraße, Waschanlage, Waschhalle'' ist ein Gebäude, in dem Fahrzeuge gereinigt werden.');
INSERT INTO gebaeudefunktion VALUES (2140, 'Storage building', 'Gebäude für Vorratshaltung', '''Gebäude für Vorratshaltung'' ist ein Gebäude, in dem Güter vorübergehend gelagert werden.');
INSERT INTO gebaeudefunktion VALUES (2141, 'Cold store', 'Kühlhaus', '''Kühlhaus'' ist ein Gebäude, das zur Lagerung von Gütern mit niedriger Temperatur dient.');
INSERT INTO gebaeudefunktion VALUES (2142, 'Warehouse', 'Speichergebäude', '''Speichergebäude'' ist ein Gebäude zur Vorratshaltung.');
INSERT INTO gebaeudefunktion VALUES (2143, 'Warehouse, storage shed, storehouse', 'Lagerhalle, Lagerschuppen, Lagerhaus', '''Lagerhalle, Lagerschuppen, Lagerhaus'' ist ein Gebäude zur Vorratshaltung von Gütern (z. B. Material, Fertigerzeugnissen).');
INSERT INTO gebaeudefunktion VALUES (2150, 'Haulage building', 'Speditionsgebäude', '''Speditionsgebäude'' bezeichnet ein Gebäude mit technischen, organisatorischen und wirtschaftlichen Einrichtungen, die der Beförderung von Gütern über räumliche Entfernungen dienen.');
INSERT INTO gebaeudefunktion VALUES (2160, 'Building for research purposes', 'Gebäude für Forschungszwecke', '''Gebäude für Forschungszwecke'' ist ein Gebäude, in dem Forschung betrieben wird.');
INSERT INTO gebaeudefunktion VALUES (2170, 'Building for raw material extraction', 'Gebäude für Grundstoffgewinnung', '''Gebäude zur Grundstoffgewinnung'' ist ein Gebäude zur Gewinnung von Grundstoffen (z.B. Erz oder Kohle).');
INSERT INTO gebaeudefunktion VALUES (2171, 'Mine', 'Bergwerk', '''Bergwerk'' ist ein Gebäude zur Gewinnung von Rohstoffen aus der Erde.');
INSERT INTO gebaeudefunktion VALUES (2172, 'Saltworks', 'Saline', '''Saline'' ist eine Anlage zur Gewinnung von Kochsalz.');
INSERT INTO gebaeudefunktion VALUES (2180, 'Social centre', 'Gebäude für betriebliche Sozialeinrichtung', '''Gebäude für betriebliche Sozialeinrichtung'' ist ein Gebäude, in dem Arbeitnehmern betriebliche Zusatzangebote gewährt werden (z. B. Kinderbetreuung, Betriebssport oder Beratung).');
INSERT INTO gebaeudefunktion VALUES (2200, 'Other commercial and industrial buildings', 'Sonstiges Gebäude für Gewerbe und Industrie', '''Betriebsgebäude'' ist ein Gebäude, in dem Arbeitskräfte und Produktionsmittel zusammengefasst sind, um Leistungen zu erbringen oder Güter herzustellen.');
INSERT INTO gebaeudefunktion VALUES (2210, 'Mill', 'Mühle', '''Mühle'' ist ein Gebäude, das zum Mahlen, zum Sägen, zum Pumpen oder zur Erzeugung von Strom dient.');
INSERT INTO gebaeudefunktion VALUES (2211, 'Windmill', 'Windmühle', '''Windmühle'' ist ein Gebäude, dessen wesentlicher Bestandteil die an einer Achse befestigten Flächen (Flügel, Schaufeln) sind, die von der Windkraft in Drehung versetzt werden.');
INSERT INTO gebaeudefunktion VALUES (2212, 'Watermill', 'Wassermühle', '''Wassermühle'' ist ein Gebäude mit einem Mühlrad, das von Wasser angetrieben wird.');
INSERT INTO gebaeudefunktion VALUES (2213, 'Pumping station', 'Schöpfwerk', '''Schöpfwerk'' ist ein Gebäude, in dem Pumpen Wasser einem höher gelegenen Vorfluter zuführen u. a. zur künstlichen Entwässerung von landwirtschaftlich genutzten Flächen und im Falle von Polder- und Mündungsschöpfwerken auch zur Sicherstellung des Hochwasser- oder Überschwemmungsschutzes.');
INSERT INTO gebaeudefunktion VALUES (2220, 'Weather station', 'Wetterstation', '''Wetterstation'' ist ein Gebäude, in dem meteorologische Daten erfasst und ausgewertet werden.');
INSERT INTO gebaeudefunktion VALUES (2310, 'Building for retail and services with housing', 'Gebäude für Handel und Dienstleistung mit Wohnen', '''Gebäude für Handel und Dienstleistungen mit Wohnen'' ist ein Gebäude, in dem Arbeitsleistungen, die nicht der Produktion von materiellen Gütern dienen, angeboten werden und in dem zusätzlich gewohnt wird.');
INSERT INTO gebaeudefunktion VALUES (2320, 'Commercial and industrial buildings with residential units', 'Gebäude für Gewerbe und Industrie mit Wohnen', '''Gebäude für Gewerbe und Industrie mit Wohnen'' ist ein Gebäude, das zum Anbieten von gewerblichen oder industriellen Tätigkeiten genutzt und in dem zusätzlich gewohnt wird.');
INSERT INTO gebaeudefunktion VALUES (2400, 'Operating building for transport facilities (general)', 'Betriebsgebäude zu Verkehrsanlagen (allgemein)', '''Betriebsgebäude zu Verkehrsanlagen (allgemein)'' ist ein Gebäude zur Aufrechterhaltung, Instandhaltung oder Überwachung von Verkehrsanlagen.');
INSERT INTO gebaeudefunktion VALUES (2410, 'Road transport building', 'Betriebsgebäude für Straßenverkehr', '''Betriebsgebäude für Straßenverkehr'' ist ein Gebäude zur Aufrechterhaltung oder Instandhaltung des Straßenverkehrs.');
INSERT INTO gebaeudefunktion VALUES (2411, 'Road maintenance depot', 'Straßenmeisterei', '''Straßenmeisterei'' ist das Verwaltungsgebäude einer Dienststelle, die für den ordnungsgemäßen Zustand von Straßen verantwortlich ist.');
INSERT INTO gebaeudefunktion VALUES (2412, 'Maintenance hall', 'Wartungshalle', '''Wartungshalle'' ist ein Gebäude zur Wartung oder Instandsetzung.');
INSERT INTO gebaeudefunktion VALUES (2420, 'Operations building for rail transport', 'Betriebsgebäude für Schienenverkehr', '''Betriebsgebäude für Schienenverkehr'' ist ein Gebäude zur Aufrechterhaltung oder Instandhaltung des Schienenverkehrs.');
INSERT INTO gebaeudefunktion VALUES (2421, 'Railway caretaker''s house', 'Bahnwärterhaus', '''Bahnwärterhaus'' ist ein Gebäude, das als Dienstwohnung für Bahnwärter dient.');
INSERT INTO gebaeudefunktion VALUES (2422, 'Engine shed, carriage shed', 'Lokschuppen, Wagenhalle', '''Lokschuppen, Wagenhalle'' ist ein Gebäude, das als Unterstellplatz für Schienenfahrzeuge dient.');
INSERT INTO gebaeudefunktion VALUES (2423, 'Signal box, block centre', 'Stellwerk, Blockstelle', '''Stellwerk, Blockstelle'' ist ein Gebäude, von dem aus die Signale und Weichen im Bahnhof und auf der freien Strecke für die Züge gestellt werden.');
INSERT INTO gebaeudefunktion VALUES (2424, 'Operations building of the freight station', 'Betriebsgebäude des Güterbahnhofs', '''Betriebsgebäude des Güterbahnhofs'' ist ein Gebäude zur Aufrechterhaltung oder Überwachung des Güterzugverkehrs.');
INSERT INTO gebaeudefunktion VALUES (2430, 'Operations building for air traffic', 'Betriebsgebäude für Flugverkehr', '''Betriebsgebäude für Flugverkehr'' ist ein Gebäude zur Aufrechterhaltung oder Überwachung des Flugverkehrs.');
INSERT INTO gebaeudefunktion VALUES (2431, 'Aircraft hangar', 'Flugzeughalle', '''Flugzeughalle'' ist ein Gebäude, in dem Flugzeuge abgestellt, inspiziert und repariert werden.');
INSERT INTO gebaeudefunktion VALUES (2440, 'Operating building for shipping traffic', 'Betriebsgebäude für Schiffsverkehr', '''Betriebsgebäude für Schiffsverkehr'' ist ein Gebäude zur Aufrechterhaltung oder Überwachung des Schiffsverkehrs.');
INSERT INTO gebaeudefunktion VALUES (2441, 'Shipyard (hall)', 'Werft (Halle)', '''Werft (Halle)'' ist ein Gebäude, in dem Schiffe gebaut und repariert werden.');
INSERT INTO gebaeudefunktion VALUES (2442, 'Dock (hall)', 'Dock (Halle)', '''Dock (Halle)'' ist ein Gebäude, in dem Schiffe trockengelegt werden.');
INSERT INTO gebaeudefunktion VALUES (2443, 'Operations building for the lock', 'Betriebsgebäude zur Schleuse', '''Betriebsgebäude zur Schleuse'' ist ein Gebäude, in dem der Schleusenbetrieb gesteuert und überwacht wird.');
INSERT INTO gebaeudefunktion VALUES (2444, 'Boathouse', 'Bootshaus', '''Bootshaus'' ist ein Gebäude, das als Unterstellplatz für kleinere Wasserfahrzeuge dient.');
INSERT INTO gebaeudefunktion VALUES (2450, 'Operating building for the cable car', 'Betriebsgebäude zur Seilbahn', '''Betriebsgebäude zur Seilbahn'' ist ein Gebäude, in dem der Seilbahnbetrieb gesteuert und überwacht wird.');
INSERT INTO gebaeudefunktion VALUES (2451, 'Tensioning device for the cable car', 'Spannwerk zur Drahtseilbahn', '''Spannwerk zur Drahtseilbahn'' ist ein Gebäude, in dem das Seil der Seilbahn gespannt und umgelenkt wird.');
INSERT INTO gebaeudefunktion VALUES (2460, 'Car park building', 'Gebäude zum Parken', '''Gebäude zum Parken'' ist ein Gebäude zum Abstellen von Fahrzeugen.');
INSERT INTO gebaeudefunktion VALUES (2461, 'Car park', 'Parkhaus', '''Parkhaus'' ist ein Gebäude, in dem Fahrzeuge auf mehreren Etagen abgestellt werden.');
INSERT INTO gebaeudefunktion VALUES (2462, 'Car park level', 'Parkdeck', '''Parkdeck'' ist ein Gebäude, in dem Fahrzeuge auf einer Etage abgestellt werden.');
INSERT INTO gebaeudefunktion VALUES (2463, 'Garage', 'Garage', '''Garage'' ist ein Gebäude, in dem Fahrzeuge abgestellt werden.');
INSERT INTO gebaeudefunktion VALUES (2464, 'Vehicle hangar', 'Fahrzeughalle', '''Fahrzeughalle'' ist ein Gebäude, in dem Fahrzeuge abgestellt, inspiziert und repariert werden.');
INSERT INTO gebaeudefunktion VALUES (2465, 'Underground car park', 'Tiefgarage', '''Tiefgarage'' ist ein Bauwerk unter der Erdoberfläche, in dem Fahrzeuge abgestellt werden.');
INSERT INTO gebaeudefunktion VALUES (2500, 'Supply building', 'Gebäude zur Versorgung', '''Gebäude zur Versorgung'' ist ein Gebäude, das die Grundversorgung mit Wasser oder Energie sicherstellt.');
INSERT INTO gebaeudefunktion VALUES (2501, 'Building for energy supply', 'Gebäude zur Energieversorgung', '''Gebäude zur Energieversorgung'' ist ein Gebäude, das die Grundversorgung mit Energie sicherstellt.');
INSERT INTO gebaeudefunktion VALUES (2510, 'Water supply building', 'Gebäude zur Wasserversorgung', '''Gebäude zur Wasserversorgung'' ist ein Gebäude, das die Grundversorgung mit Wasser sicherstellt.');
INSERT INTO gebaeudefunktion VALUES (2511, 'Waterworks', 'Wasserwerk', '''Wasserwerk'' ist ein Gebäude zur Aufbereitung und Bereitstellung von Trinkwasser.');
INSERT INTO gebaeudefunktion VALUES (2512, 'Pumping station', 'Pumpstation', '''Pumpstation'' ist ein Gebäude an einem Rohrleitungssystem, in dem eine oder mehrere Pumpen zur Wasserversorgung eingebaut sind.');
INSERT INTO gebaeudefunktion VALUES (2513, 'Water tank', 'Wasserbehälter', '''Wasserbehälter'' ist ein Gebäude, in dem Wasser gespeichert wird, das zum Ausgleich der Differenz zwischen Wasserzuführung und -abgabe dient.');
INSERT INTO gebaeudefunktion VALUES (2520, 'Building for electricity supply', 'Gebäude zur Elektrizitätsversorgung', '''Gebäude zur Elektrizitätsversorgung'' ist ein Gebäude, in dem Elektrizität erzeugt oder übertragen wird.');
INSERT INTO gebaeudefunktion VALUES (2521, 'Power station', 'Elektrizitätswerk', '''Elektrizitätswerk'' ist ein Gebäude, in dem Elektrizität erzeugt wird.');
INSERT INTO gebaeudefunktion VALUES (2522, 'Substation', 'Umspannwerk', '''Umspannwerk'' ist ein Gebäude, in dem verschiedene Spannungsebenen des elektrischen Versorgungsnetzes miteinander verbunden werden.');
INSERT INTO gebaeudefunktion VALUES (2523, 'Converter', 'Umformer', '''Umformer'' ist ein kleines Gebäude in dem ein Transformator zum Umformen von Gleichstrom in Wechselstrom oder von Gleichstrom in Gleichstrom anderer Spannung untergebracht ist.');
INSERT INTO gebaeudefunktion VALUES (2527, 'Reactor building', 'Reaktorgebäude', '''Reaktorgebäude'' ist ein zentrales Gebäude eines Kernkraftwerkes, in dem aus radioaktivem Material mittels Kernspaltung Wärmeenergie erzeugt wird.');
INSERT INTO gebaeudefunktion VALUES (2528, 'Turbine building', 'Turbinenhaus', '''Turbinenhaus'' ist ein Gebäude, in dem eine Kraftmaschine die Energie von strömendem Dampf, Gas, Wasser oder Wind unmittelbar in elektrische Energie umsetzt.');
INSERT INTO gebaeudefunktion VALUES (2529, 'Boiler house', 'Kesselhaus', '''Kesselhaus'' ist ein Gebäude, in dem ein Dampfkessel mitsamt seiner Feuerung aufgestellt ist.');
INSERT INTO gebaeudefunktion VALUES (2540, 'Telecommunications building', 'Gebäude für Fernmeldewesen', '''Gebäude für Fernmeldewesen'' ist ein Gebäude, in dem sich Einrichtungen zur Telekommunikation befinden.');
INSERT INTO gebaeudefunktion VALUES (2560, 'Building on underground pipes', 'Gebäude an unterirdischen Leitungen', '''Gebäude an unterirdischen Leitungen'' ist ein Gebäude, das zur Kontrolle von Versorgungsleitungen unter der Erde dient.');
INSERT INTO gebaeudefunktion VALUES (2570, 'Gas supply building', 'Gebäude zur Gasversorgung', '''Gebäude zur Gasversorgung'' ist ein Gebäude, in dem sich Gasanlagen befinden.');
INSERT INTO gebaeudefunktion VALUES (2571, 'Gasworks', 'Gaswerk', '''Gaswerk'' ist ein Gebäude, in dem technische Gase hergestellt, gespeichert und bereitgestellt werden.');
INSERT INTO gebaeudefunktion VALUES (2580, 'Heating plant', 'Heizwerk', '''Heizwerk'' ist ein Gebäude zur zentralen Erzeugung von Wärme (z.B. für Warmwasserversorgung).');
INSERT INTO gebaeudefunktion VALUES (2590, 'Supply system building', 'Gebäude zur Versorgungsanlage', '''Gebäude zur Versorgungsanlage'' ist ein Gebäude, in dem sich Anlagen zur Unterstützung von Versorgungseinrichtungen befinden.');
INSERT INTO gebaeudefunktion VALUES (2591, 'Pumping station (not for water supply)', 'Pumpwerk (nicht für Wasserversorgung)', '''Pumpwerk (nicht für Wasserversorgung)'' ist ein Gebäude, in dem Wasser aus einem niedriger gelegenen Gewässer in ein höher gelegenes gepumpt wird.');
INSERT INTO gebaeudefunktion VALUES (2600, 'Waste disposal building', 'Gebäude zur Entsorgung', '''Gebäude zur Entsorgung'' ist ein Gebäude zur Beseitigung von Abwässern oder Abfällen.');
INSERT INTO gebaeudefunktion VALUES (2610, 'Sewage disposal building', 'Gebäude zur Abwasserbeseitigung', '''Gebäude zur Abwasserbeseitigung'' ist ein Gebäude zur Reinigung von verschmutztem Wasser oder zur Entsorgung von Fäkalien.');
INSERT INTO gebaeudefunktion VALUES (2611, 'Sewage treatment plant building', 'Gebäude der Kläranlage', '''Gebäude der Kläranlage'' ist ein Gebäude innerhalb einer Kläranlage.');
INSERT INTO gebaeudefunktion VALUES (2612, 'Toilet', 'Toilette', '''Toilette'' ist eine Einrichtung mit sanitären Vorrichtungen zur Aufnahme von Körperausscheidungen.');
INSERT INTO gebaeudefunktion VALUES (2620, 'Waste treatment buildings', 'Gebäude zur Abfallbehandlung', '''Gebäude zur Abfallbehandlung'' ist ein Gebäude zur Behandlung von Abfällen.');
INSERT INTO gebaeudefunktion VALUES (2621, 'Waste bunker', 'Müllbunker', '''Müllbunker'' ist ein Gebäude, in dem Müll gelagert wird.');
INSERT INTO gebaeudefunktion VALUES (2622, 'Waste incineration building', 'Gebäude zur Müllverbrennung', '''Gebäude zur Müllverbrennung'' ist ein Gebäude in dem Abfälle mit chemisch/physikalischen und biologischen oder thermischen Verfahren oder Kombination dieser Verfahren behandelt werden.');
INSERT INTO gebaeudefunktion VALUES (2623, 'Landfill building', 'Gebäude der Abfalldeponie', '''Gebäude der Abfalldeponie'' ist ein Gebäude auf einer Fläche, die zur endgültigen Lagerung von Abfällen genutzt wird.');
INSERT INTO gebaeudefunktion VALUES (2700, 'Building for agriculture and forestry', 'Gebäude für Land- und Forstwirtschaft', '''Gebäude für Land- und Forstwirtschaft'' ist ein Gebäude, das land- und forstwirtschaftlichen Zwecken dient.');
INSERT INTO gebaeudefunktion VALUES (2720, 'Farm and forestry building', 'Land- und forstwirtschaftliches Betriebsgebäude', '''Land- und forstwirtschaftliches Betriebsgebäude'' ist ein Gebäude zur Produktion von land- und forstwirtschaftlichen Gütern.');
INSERT INTO gebaeudefunktion VALUES (2721, 'Barn', 'Scheune', '''Scheune'' ist ein Gebäude zur Lagerung landwirtschaftlicher Güter (z. B. Stroh, Heu und Getreide).');
INSERT INTO gebaeudefunktion VALUES (2723, 'Shed', 'Schuppen', '''Schuppen'' ist ein Gebäude in einfacher Ausführung, das als Abstellplatz oder als Lagerraum zur Unterbringung von Fahrzeugen, Geräten und Materialien der Land- und Forstwirtschaft verwendet wird.');
INSERT INTO gebaeudefunktion VALUES (2724, 'Stable', 'Stall', '''Stall'' ist ein Gebäude, in dem Tiere untergebracht sind.');
INSERT INTO gebaeudefunktion VALUES (2726, 'Barn and stable', 'Scheune und Stall', '''Scheune und Stall'' ist ein Gebäude, in dem landwirtschaftliche Güter gelagert werden (z.B. Stroh, Heu oder Getreide) und in dem auch Tiere untergebracht sein können.');
INSERT INTO gebaeudefunktion VALUES (2727, 'Stable for large-scale animal husbandry', 'Stall für Tiergroßhaltung', '''Stall für Tiergroßhaltung'' ist ein Gebäude zur Unterbringung einer großen Anzahl von Tieren.');
INSERT INTO gebaeudefunktion VALUES (2728, 'Riding arena', 'Reithalle', '''Reithalle'' ist ein Gebäude zum Ausüben des Reitsports.');
INSERT INTO gebaeudefunktion VALUES (2729, 'Farm building', 'Wirtschaftsgebäude', '''Wirtschaftsgebäude'' ist ein Gebäude, das zu wirtschaftlichen Zwecken dient (z.B. Lager- oder Produktionshallen).');
INSERT INTO gebaeudefunktion VALUES (2732, 'Alpine hut', 'Almhütte', '''Almhütte'' ist ein einfaches, hoch in den Bergen gelegenes Gebäude, das überwiegend weidewirtschaftlichen Zwecken dient und hauptsächlich im Sommer genutzt wird.');
INSERT INTO gebaeudefunktion VALUES (2735, 'Hunting lodge', 'Jagdhaus, Jagdhütte', '''Jagdhaus, Jagdhütte'' ist ein Gebäude, das als Unterkunft bei der Jagd dient.');
INSERT INTO gebaeudefunktion VALUES (2740, 'Greenhouse', 'Treibhaus, Gewächshaus', '''Treibhaus, Gewächshaus'' ist ein Gebäude mit lichtdurchlässigem Dach und Wänden, das durch künstliche Klimagestaltung der Aufzucht oder Produktion von Pflanzen dient.');
INSERT INTO gebaeudefunktion VALUES (2741, 'Greenhouse', 'Treibhaus', '''Treibhaus'' ist ein Gebäude mit lichtdurchlässigem Dach und Wänden, das durch künstliche Klimagestaltung der Aufzucht oder Produktion von Pflanzen dient.');
INSERT INTO gebaeudefunktion VALUES (2742, 'Greenhouse, movable', 'Gewächshaus, verschiebbar', '''Gewächshaus, verschiebbar'' ist ein Gebäude mit lichtdurchlässigem Dach und Wänden, das durch künstliche Klimagestaltung der Aufzucht oder Produktion von Pflanzen dient und dabei z. B. auf Schienen hin- und her bewegt werden kann.');
INSERT INTO gebaeudefunktion VALUES (3000, 'Public building', 'Gebäude für öffentliche Zwecke', '''Gebäude für öffentliche Zwecke'' ist ein Gebäude das der Allgemeinheit dient.');
INSERT INTO gebaeudefunktion VALUES (3010, 'Administration building', 'Verwaltungsgebäude', '''Verwaltungsgebäude'' ist ein Gebäude, in dem Verwaltungstätigkeiten durchgeführt werden.');
INSERT INTO gebaeudefunktion VALUES (3011, 'Parliament', 'Parlament', '''Parlament'' ist ein Gebäude, in dem die gesetzgebende Volksvertretung (Bundestag, Landtag) tagt.');
INSERT INTO gebaeudefunktion VALUES (3012, 'Town hall', 'Rathaus', '''Rathaus'' ist ein Gebäude, in dem der Vorstand einer Gemeinde seinen Amtssitz hat und/oder Teile der Verwaltung untergebracht sind.');
INSERT INTO gebaeudefunktion VALUES (3013, 'Post Office', 'Post', '''Post ist ein Gebäude, in dem die Post Dienstleistungen anbietet.');
INSERT INTO gebaeudefunktion VALUES (3014, 'Customs office', 'Zollamt', '''Zollamt'' ist ein Gebäude für die Zollabfertigung an der Staatsgrenze (Grenzzollamt) oder im Inland (Binnenzollamt).');
INSERT INTO gebaeudefunktion VALUES (3015, 'Courthouse', 'Gericht', '''Gericht'' ist ein Gebäude, in dem Rechtsprechung und Rechtspflege stattfinden.');
INSERT INTO gebaeudefunktion VALUES (3016, 'Embassy, Consulate', 'Botschaft, Konsulat', '''Botschaft, Konsulat'' ist ein Gebäude, in dem eine ständige diplomatische Vertretung ersten Rangs eines fremden Staates oder einer internationalen Organisation untergebracht ist.');
INSERT INTO gebaeudefunktion VALUES (3017, 'District administration', 'Kreisverwaltung', '''Kreisverwaltung'' ist ein Gebäude, in dem sich die Verwaltung eines Landkreises befindet.');
INSERT INTO gebaeudefunktion VALUES (3018, 'District government', 'Bezirksregierung', '''Bezirksregierung'' ist ein Gebäude, in dem sich die Regierung eines Bezirks befindet.');
INSERT INTO gebaeudefunktion VALUES (3019, 'Tax office', 'Finanzamt', '''Finanzamt'' ist ein Gebäude, in dem sich eine örtliche Behörde der Finanzverwaltung befindet.');
INSERT INTO gebaeudefunktion VALUES (3020, 'Building for education and research', 'Gebäude für Bildung und Forschung', '''Gebäude für Bildung und Forschung'' ist ein Gebäude, in dem durch Ausbildung Wissen und Können auf verschiedenen Gebieten vermittelt werden bzw. wo neues Wissen durch wissenschaftliche Tätigkeit gewonnen wird.');
INSERT INTO gebaeudefunktion VALUES (3021, 'General education school', 'Allgemein bildende Schule', '''Allgemein bildende Schule'' ist ein Gebäude, in dem Kindern, Jugendlichen und Erwachsenen durch planmäßigen Unterricht Wissen vermittelt wird.');
INSERT INTO gebaeudefunktion VALUES (3022, 'Vocational school', 'Berufsbildende Schule', '''Berufsbildende Schule'' ist ein Gebäude, in dem berufsbezogenes und fachgebundenes Wissen vermittelt wird.');
INSERT INTO gebaeudefunktion VALUES (3023, 'University building', 'Hochschulgebäude (Fachhochschule, Universität)', '''Hochschulgebäude (Fachhochschule, Universität)'' ist ein Gebäude, in dem Wissenschaften gelehrt und Forschung betrieben wird.');
INSERT INTO gebaeudefunktion VALUES (3024, 'Research institute', 'Forschungsinstitut', '''Forschungsinstitut'' ist ein Gebäude, in dem Forschung betrieben wird.');
INSERT INTO gebaeudefunktion VALUES (3030, 'Building for cultural purposes', 'Gebäude für kulturelle Zwecke', '''Gebäude für kulturelle Zwecke'' ist ein Gebäude, in dem kulturelle Ereignisse stattfinden sowie ein Gebäude von kulturhistorischer Bedeutung.');
INSERT INTO gebaeudefunktion VALUES (3031, 'Castle', 'Schloss', '''Schloss'' ist ein Gebäude, das als repräsentativer Wohnsitz vor allem des Adels dient oder diente.');
INSERT INTO gebaeudefunktion VALUES (3032, 'Theatre, Opera', 'Theater, Oper', '''Theater, Oper'' ist ein Gebäude, in dem Bühnenstücke aufgeführt werden.');
INSERT INTO gebaeudefunktion VALUES (3033, 'Concert hall', 'Konzertgebäude', '''Konzertgebäude'' ist ein Gebäude, in dem Musikaufführungen stattfinden.');
INSERT INTO gebaeudefunktion VALUES (3034, 'Museum', 'Museum', '''Museum'' ist ein Gebäude, in dem Sammlungen von (historischen) Objekten oder Reproduktionen davon ausgestellt werden.');
INSERT INTO gebaeudefunktion VALUES (3035, 'Radio, television', 'Rundfunk, Fernsehen', '''Rundfunk-, Fernsehen'' ist ein Gebäude, in dem Radio- und Fernsehprogramme produziert und gesendet werden.');
INSERT INTO gebaeudefunktion VALUES (3036, 'Event building', 'Veranstaltungsgebäude', '''Veranstaltungsgebäude'' ist ein Gebäude, das hauptsächlich für kulturelle Zwecke wie z. B. Aufführungen, Ausstellungen, Konzerte genutzt wird.');
INSERT INTO gebaeudefunktion VALUES (3037, 'Library, bookshop', 'Bibliothek, Bücherei', '''Bibliothek, Bücherei'' ist ein Gebäude, in dem Bücher und Zeitschriften gesammelt, aufbewahrt und ausgeliehen werden.');
INSERT INTO gebaeudefunktion VALUES (3038, 'Castle, fortress', 'Burg, Festung', '''Burg, Festung'' ist ein Gebäude innerhalb einer befestigten Anlage.');
INSERT INTO gebaeudefunktion VALUES (3040, 'Building for religious use', 'Gebäude für religiöse Zwecke', '''Gebäude für religiöse Zwecke'' ist ein Gebäude, das bei Gottesdiensten oder sonstigen religiösen Veranstaltungen als Versammlungsort dient.');
INSERT INTO gebaeudefunktion VALUES (3041, 'Church', 'Kirche', '''Kirche'' ist ein Gebäude, in dem sich Christen zu Gottesdiensten versammeln.');
INSERT INTO gebaeudefunktion VALUES (3042, 'Synagogue', 'Synagoge', '''Synagoge'' ist ein Gebäude, in dem sich Personen jüdischen Glaubens zu Gottesdiensten, zum Schriftstudium und zur Unterweisung versammeln.');
INSERT INTO gebaeudefunktion VALUES (3043, 'Chapel', 'Kapelle', '''Kapelle'' ist ein kleines Gebäude (Gebets-, Tauf-, Grabkapelle) für (christliche) gottesdienstliche Zwecke.');
INSERT INTO gebaeudefunktion VALUES (3044, 'Community centre', 'Gemeindehaus', '''Gemeindehaus'' ist ein Gebäude, das Personen einer bestimmten Glaubensgemeinschaft zu verschiedenen Zwecken dient.');
INSERT INTO gebaeudefunktion VALUES (3045, 'Place of worship', 'Gotteshaus', '''Gotteshaus'' ist ein Gebäude, in dem Gläubige einer nichtchristlichen Religionsgemeinschaft religiöse Handlungen vollziehen.');
INSERT INTO gebaeudefunktion VALUES (3046, 'Mosque', 'Moschee', '''Moschee'' ist ein Gebäude, in dem sich Personen muslimischen Glaubens zum Gebet versammeln und das als sozialer Treffpunkt dient.');
INSERT INTO gebaeudefunktion VALUES (3047, 'Temple', 'Tempel', '''Tempel'' ist ein Gebäude, das Personen in der Ausübung ihrer Religion (z. B. Buddhisten, Hinduisten) als Versammlungsort dient.');
INSERT INTO gebaeudefunktion VALUES (3048, 'Monastery', 'Kloster', '''Kloster'' ist ein Gebäude, in dem Angehörige eines Ordens in einer auf die Ausübung ihrer Religion konzentrierten Lebensweise zusammenleben.');
INSERT INTO gebaeudefunktion VALUES (3050, 'Healthcare building', 'Gebäude für Gesundheitswesen', '''Gebäude für Gesundheitswesen'' ist ein Gebäude, das der ambulanten oder stationären Behandlung und Pflege von Patienten dient.');
INSERT INTO gebaeudefunktion VALUES (3051, 'Hospital', 'Krankenhaus', '''Krankenhaus'' ist ein Gebäude, in dem Kranke behandelt und/oder gepflegt werden.');
INSERT INTO gebaeudefunktion VALUES (3052, 'Sanatorium, nursing home, nursing ward', 'Heilanstalt, Pflegeanstalt, Pflegestation', '''Heilanstalt, Pflegeanstalt, Pflegestation'' ist ein Gebäude, das einer länger andauernden Behandlung von Patienten dient.');
INSERT INTO gebaeudefunktion VALUES (3053, 'Medical centre, polyclinic', 'Ärztehaus, Poliklinik', '''Ärztehaus, Poliklinik'' ist ein Gebäude, in dem mehrere Ärzte unterschiedlicher Fachrichtung Kranke ambulant behandeln und versorgen.');
INSERT INTO gebaeudefunktion VALUES (3054, 'Ambulance station', 'Rettungswache', '''Rettungswache'' ist ein Gebäude des Rettungsdienstes, in dem sich die Besatzungen der Rettungsdienstfahrzeuge in ihrer einsatzfreien Zeit aufhalten. Hier sind auch die Fahrzeuge und Geräte untergebracht.');
INSERT INTO gebaeudefunktion VALUES (3060, 'Building for social purposes', 'Gebäude für soziale Zwecke', '''Gebäude für soziale Zwecke'' ist ein Gebäude, in dem ältere Menschen, Obdachlose, Jugendliche oder Kinder betreut werden.');
INSERT INTO gebaeudefunktion VALUES (3061, 'Youth recreation centre', 'Jugendfreizeitheim', '''Jugendfreizeitheim'' ist ein Gebäude der offenen Kinder- und Jugendarbeit.');
INSERT INTO gebaeudefunktion VALUES (3062, 'Leisure centre, clubhouse, village hall, community centre', 'Freizeit-, Vereinsheim, Dorfgemeinschafts-, Bürgerhaus', '''Freizeit-, Vereinsheim, Dorfgemeinschafts-, Bürgerhaus'' ist ein Gebäude zur gemeinschaftlichen Nutzung unterschiedlicher sozialer Gruppen.');
INSERT INTO gebaeudefunktion VALUES (3063, 'Senior citizens'' leisure centre', 'Seniorenfreizeitstätte', '''Seniorenfreizeitstätte'' ist ein Gebäude zur Ausübung seniorengerechter Freizeitaktivitäten.');
INSERT INTO gebaeudefunktion VALUES (3064, 'Homeless shelter', 'Obdachlosenheim', '''Obdachlosenheim'' ist ein Gebäude, in dem Obdachlose untergebracht sind und betreut werden.');
INSERT INTO gebaeudefunktion VALUES (3065, 'Crèche, kindergarten, day care centre', 'Kinderkrippe, Kindergarten, Kindertagesstätte', '''Kinderkrippe, Kindergarten, Kindertagesstätte'' ist ein Gebäude, in dem Kinder im Vorschulalter betreut werden.');
INSERT INTO gebaeudefunktion VALUES (3066, 'Asylum centre', 'Asylbewerberheim', '''Asylbewerberheim'' ist ein Gebäude, in dem Asylbewerber ohne Aufenthaltsgenehmigung für Deutschland eine gewisse Zeit untergebracht sind.');
INSERT INTO gebaeudefunktion VALUES (3070, 'Security and order building', 'Gebäude für Sicherheit und Ordnung', '''Gebäude für Sicherheit und Ordnung'' ist ein Gebäude, das für Personen und Gegenstände dient, die zur Verhütung oder Bekämpfung von Rechtsverletzungen und zum Katastrophenschutz eingesetzt werden, oder zur Unterbringung von Strafgefangenen.');
INSERT INTO gebaeudefunktion VALUES (3071, 'Police', 'Polizei', '''Polizei'' ist ein Gebäude für Polizeibedienstete, die in einem bestimmten Gebiet für Sicherheit und Ordnung zuständig sind.');
INSERT INTO gebaeudefunktion VALUES (3072, 'Fire brigade', 'Feuerwehr', '''Feuerwehr'' ist ein Gebäude der Feuerwehr, in dem Personen und Geräte zur Brandbekämpfung sowie zu anderen Hilfeleistungen untergebracht sind.');
INSERT INTO gebaeudefunktion VALUES (3073, 'Military barracks', 'Kaserne', '''Kaserne'' ist ein Gebäude zur ortsfesten Unterbringung von Angehörigen der Bundeswehr und der Polizei sowie deren Ausrüstung.');
INSERT INTO gebaeudefunktion VALUES (3074, 'Shelter', 'Schutzbunker', '''Schutzbunker'' ist ein Gebäude zum Schutz der Zivilbevölkerung vor militärischen Angriffen.');
INSERT INTO gebaeudefunktion VALUES (3075, 'Correctional centre', 'Justizvollzugsanstalt', '''Justizvollzugsanstalt'' ist ein Gebäude zur Unterbringung von Untersuchungshäftlingen und Strafgefangenen.');
INSERT INTO gebaeudefunktion VALUES (3080, 'Cemetery building', 'Friedhofsgebäude', '''Friedhofsgebäude'' ist ein Gebäude, das zur Aufrechterhaltung des Friedhofbetriebes dient (z. B. Verwaltung, Leichenhalle, Krematorium).');
INSERT INTO gebaeudefunktion VALUES (3081, 'Funeral parlour', 'Trauerhalle', '''Trauerhalle'' ist ein Gebäude, welches für Bestattungszeremonien bestimmt ist und zur kurzzeitigen Aufbewahrung von Toten dienen kann.');
INSERT INTO gebaeudefunktion VALUES (3082, 'Crematorium', 'Krematorium', '''Krematorium'' ist ein Gebäude, in dem Feuerbestattungen durchgeführt werden.');
INSERT INTO gebaeudefunktion VALUES (3090, 'Reception building', 'Empfangsgebäude', '''Empfangsgebäude'' ist ein Gebäude mit Wartesaal, Fahrkarten- und Gepäckschalter zur Abwicklung des Straßen-, Schienen-, Seilbahn-, Luft- und Schiffsverkehrs.');
INSERT INTO gebaeudefunktion VALUES (3091, 'Railway station building', 'Bahnhofsgebäude', '''Bahnhofsgebäude'' ist ein Gebäude u. a. mit Wartebereich und Fahrkartenausgabe zur Abwicklung des Bahnverkehrs.');
INSERT INTO gebaeudefunktion VALUES (3092, 'Airport building', 'Flughafengebäude', '''Flughafengebäude'' ist ein Gebäude u. a. mit Wartebereich, Flugticket- und Gepäckschalter zur Abwicklung des Flugverkehrs.');
INSERT INTO gebaeudefunktion VALUES (3094, 'Building leading to the underground station', 'Gebäude zum U-Bahnhof', '''Gebäude zum U-Bahnhof'' ist ein Gebäude u. a. mit Wartebereich und Fahrkartenausgabe zur Abwicklung des U-Bahn-Verkehrs.');
INSERT INTO gebaeudefunktion VALUES (3095, 'Building leading to the urban railway station', 'Gebäude zum S-Bahnhof', '''Gebäude zum S-Bahnhof'' ist ein Gebäude u. a. mit Wartebereich und Fahrkartenausgabe zur Abwicklung des S-Bahn-Verkehrs.');
INSERT INTO gebaeudefunktion VALUES (3097, 'Bus station building', 'Gebäude zum Busbahnhof', '''Gebäude zum Busbahnhof'' ist ein Gebäude auf dem Busbahnhof, das zur Abwicklung des Busverkehrs dient.');
INSERT INTO gebaeudefunktion VALUES (3098, 'Shipping reception building', 'Empfangsgebäude Schifffahrt', '''Empfangsgebäude Schifffahrt'' ist ein Gebäude u. a. mit Wartebereich, Fahrticket- und Gepäckschalter zur Abwicklung des Schiffsverkehrs.');
INSERT INTO gebaeudefunktion VALUES (3100, 'Building for public purposes with housing', 'Gebäude für öffentliche Zwecke mit Wohnen', '''Gebäude für öffentliche Zwecke mit Wohnen'' ist ein Gebäude, das der Allgemeinheit dient und auch zum Wohnen genutzt wird.');
INSERT INTO gebaeudefunktion VALUES (3200, 'Building for recreational purposes', 'Gebäude für Erholungszwecke', '''Gebäude für Erholungszwecke'' ist ein Gebäude zur Freizeitgestaltung mit dem Ziel der Erhaltung und Wiederherstellung der Leistungsfähigkeit des Menschen.');
INSERT INTO gebaeudefunktion VALUES (3210, 'Building for sports purposes', 'Gebäude für Sportzwecke', '''Gebäude für Sportzwecke'' ist ein Gebäudes, in dem verschiedene Sportarten ausgeübt werden.');
INSERT INTO gebaeudefunktion VALUES (3211, 'Sports hall, gymnasium', 'Sport-, Turnhalle', '''Sport-, Turnhalle'' ist ein Gebäude, das für den Turnunterricht und für sportliche Betätigungen in der Freizeit errichtet und dementsprechend ausgestattet ist.');
INSERT INTO gebaeudefunktion VALUES (3212, 'Building facing the sports field', 'Gebäude zum Sportplatz', '''Gebäude zum Sportplatz'' ist ein Gebäude auf einer Fläche, die zur sportlichen Betätigung genutzt wird.');
INSERT INTO gebaeudefunktion VALUES (3220, 'Bathhouse', 'Badegebäude', '''Badegebäude'' ist ein Gebäude, in dem sich Anlagen zur Erholung und sportlichen Betätigung im Wasser befinden.');
INSERT INTO gebaeudefunktion VALUES (3221, 'Indoor swimming pool', 'Hallenbad', '''Hallenbad'' ist ein Gebäude mit Schwimmbecken und zugehörigen Einrichtungen (z. B. Umkleidekabinen).');
INSERT INTO gebaeudefunktion VALUES (3222, 'Building at the outdoor pool', 'Gebäude im Freibad', '''Gebäude im Freibad'' ist ein Gebäude, das sich in einer Außenanlage mit Schwimmbecken und zugehörigen Einrichtungen (z. B. Umkleidekabinen) befindet.');
INSERT INTO gebaeudefunktion VALUES (3230, 'Building in the stadium', 'Gebäude im Stadion', '''Gebäude im Stadion'' ist ein Gebäude, das sich in einer großen Anlage für sportliche Aktivitäten und Wettkämpfe befindet.');
INSERT INTO gebaeudefunktion VALUES (3240, 'Building for spa facilities', 'Gebäude für Kurbetrieb', '''Gebäude für Kurbetrieb'' ist ein Gebäude, in dem Maßnahmen zur Erholung oder Rehabilitation durchgeführt werden.');
INSERT INTO gebaeudefunktion VALUES (3241, 'Bathhouse for medical purposes', 'Badegebäude für medizinische Zwecke', '''Badegebäude für medizinische Zwecke'' ist ein Gebäude, in dem Bäder zur therapeutischen Anwendung durchgeführt werden.');
INSERT INTO gebaeudefunktion VALUES (3242, 'Sanatorium', 'Sanatorium', '''Sanatorium'' ist ein Gebäude mit zugehörigen Einrichtungen, das klimagünstig gelegen ist, unter fachärztlicher Leitung steht und zur Behandlung chronisch Kranker und Genesender bestimmt ist, für die kein Krankenhausaufenthalt in Frage kommt.');
INSERT INTO gebaeudefunktion VALUES (3260, 'Buildings in the zoo', 'Gebäude im Zoo', '''Gebäude im Zoo'' ist ein Gebäude, das sich in einer parkartigen Anlage zur Haltung und öffentlichen Zurschaustellung verschiedener Tierarten befindet.');
INSERT INTO gebaeudefunktion VALUES (3261, 'Reception building of the zoo', 'Empfangsgebäude des Zoos', '''Empfangsgebäude des Zoos'' ist ein Gebäude, das sich im Eingangsbereich des Zoos befindet u. a. mit Wartebereich und Einlasskontrolle.');
INSERT INTO gebaeudefunktion VALUES (3262, 'Aquarium, terrarium, aviary', 'Aquarium, Terrarium, Voliere', '''Aquarium, Terrarium, Voliere'' ist ein Gebäude, in dem Fische und Wasserpflanzen, Reptilien und Amphibien oder Vögel gehalten und gezüchtet werden.');
INSERT INTO gebaeudefunktion VALUES (3263, 'Animal show house', 'Tierschauhaus', '''Tierschauhaus'' ist ein Gebäude, in dem Tiere untergebracht sind und Besuchern gezeigt werden.');
INSERT INTO gebaeudefunktion VALUES (3264, 'Stable at the zoo', 'Stall im Zoo', '''Stall im Zoo'' ist ein Gebäude, das meist zur separaten Unterbringung der Zootiere dient.');
INSERT INTO gebaeudefunktion VALUES (3270, 'Building in the botanical garden', 'Gebäude im botanischen Garten', '''Gebäude im botanischen Garten'' ist ein Gebäude, das sich in einer parkartigen Anlage mit thematisch geordneter Anpflanzung befindet.');
INSERT INTO gebaeudefunktion VALUES (3271, 'Reception building of the botanical garden', 'Empfangsgebäude des botanischen Gartens', '''Empfangsgebäude des botanischen Gartens'' ist ein Gebäude, das sich im Eingangsbereich des botanischen Gartens befindet u. a. mit Wartebereich und Einlasskontrolle.');
INSERT INTO gebaeudefunktion VALUES (3272, 'Greenhouse (Botany)', 'Gewächshaus (Botanik)', '''Gewächshaus (Botanik)'' ist ein Gebäude, welches das geschützte und kontrollierte Kultivieren von Pflanzen ermöglicht.');
INSERT INTO gebaeudefunktion VALUES (3273, 'Plant show house', 'Pflanzenschauhaus', '''Pflanzenschauhaus'' ist ein Gebäude, in dem Pflanzen unterschiedlicher Klima- oder Vegetationszonen ausgestellt sind und Besuchern gezeigt werden.');
INSERT INTO gebaeudefunktion VALUES (3280, 'Buildings for other recreational facilities', 'Gebäude für andere Erholungseinrichtung', '''Gebäude für andere Erholungseinrichtung'' ist ein Gebäude, das einer anderen Art der Erholung dient.');
INSERT INTO gebaeudefunktion VALUES (3281, 'Shelter', 'Schutzhütte', '''Schutzhütte'' ist ein Gebäude zum Schutz vor Unwetter.');
INSERT INTO gebaeudefunktion VALUES (3290, 'Tourist information centre', 'Touristisches Informationszentrum', '''Touristisches Informationszentrum'' ist eine Auskunftsstelle für Touristen.');
INSERT INTO gebaeudefunktion VALUES (9998, 'Cannot be specified according to sources', 'Nach Quellenlage nicht zu spezifizieren', '''Nach Quellenlage nicht zu spezifizieren'' bedeutet, dass keine Aussage über die Werteart gemacht werden kann.');


ALTER TABLE "sie05_p" ADD CONSTRAINT gebaeudefunktion_fk FOREIGN KEY (gfk) REFERENCES gebaeudefunktion(code);


-- Attribute: besondereverkehrsbedeutung
CREATE TABLE besondereverkehrsbedeutung (
                                            code VARCHAR(4) PRIMARY KEY,
                                            name_en TEXT,
                                            name_de TEXT,
                                            definition_de TEXT,
                                            CONSTRAINT check_column_format CHECK (
                                                code ~ '^[0-9]{4}$'
                                                OR LENGTH(code) = 4
)
    );

INSERT INTO besondereverkehrsbedeutung VALUES (1000, 'Interurban traffic', 'Überörtlicher Verkehr' , '''Überörtlicher Verkehr'' beschreibt das durchgehende Straßennetz des tatsächlich stattfindenden Verkehrs, über den aufgrund des Ausbauzustandes und der örtlichen Verkehrsregelung der überörtliche Verkehr geleitet wird. Dieser ist unabhängig von gesetzlichen Festlegungen (z. B. Landesstraßengesetz). Deshalb richtet er sich auch nicht nach der Widmung. Die Werteart BVB 1000 beschreibt somit gleichzeitig den überörtlichen Verkehr und den dazugehörigen innerörtlichen Durchgangsverkehr.');
INSERT INTO besondereverkehrsbedeutung VALUES (1003, 'Local transport', 'Nahverkehr' , '''Nahverkehr'' beschreibt sowohl den zwischenörtlichen Verkehr ohne überörtliche Bedeutung, als auch den innerörtlichen Durchgangsverkehr des angebundenen Ortes.');
INSERT INTO besondereverkehrsbedeutung VALUES (2000, 'Local traffic', 'Ortsverkehr' , '''Ortsverkehr'' beschreibt den tatsächlich stattfindenden Verkehr auf einer Straße (Ortsstraße), unabhängig von örtlichen Festlegungen (z. B. Ortssatzungen). Unter Ortsverkehr werden sowohl Sammel- als auch Anliegerverkehr subsumiert. Er bezeichnet sämtliche innerörtliche Verkehrswege, die nicht dem überörtlichen Verkehr oder Nahverkehr zugeordnet werden können.');
INSERT INTO besondereverkehrsbedeutung VALUES (2001, 'Collective transport', 'Sammelverkehr' , '''Sammelverkehr'' beschreibt den tatsächlich stattfindenden Verkehr auf einer Straße (Sammelstraße), unabhängig von örtlichen Festlegungen (z. B. Ortssatzungen). Die Sammelstraße leitet hauptsächlich den innerörtlichen Verkehr von den Anliegerstraßen zum überörtlichen Verkehr oder Nahverkehr.');
INSERT INTO besondereverkehrsbedeutung VALUES (2002, 'Residential traffic', 'Anliegerverkehr' , '''Anliegerverkehr'' beschreibt den tatsächlich stattfindenden Verkehr auf einer Straße (Anliegerstraße), unabhängig von örtlichen Festlegungen (z. B. Ortssatzungen). Die Anliegerstraße ist eine Straße auf die jeder Straßenanlieger von seinem Anwesen aus freie Zufahrt hat und die nicht die Funktion einer Sammelstraße übernimmt.');


ALTER TABLE "ver01_l" ADD CONSTRAINT besondereverkehrsbedeutung_fk FOREIGN KEY (bvb) REFERENCES besondereverkehrsbedeutung(code);


-- Attribute: widmung_traffic
CREATE TABLE widmung (
                     code VARCHAR(4),
                     objart VARCHAR(5),
                     name_en TEXT,
                     name_de TEXT,
                     definition_de TEXT,
                     PRIMARY KEY (code, objart),
                     CONSTRAINT check_column_format CHECK (
                         code ~ '^[0-9]{4}$'
                         OR LENGTH(code) = 4
)
    );
INSERT INTO widmung VALUES (1301, 42002, 'Federal motorway', 'Bundesautobahn' , '''Bundesautobahn'' ist eine durch Verwaltungsakt zur Bundesautobahn gewidmete Bundesfernstraße.');
INSERT INTO widmung VALUES (1303, 42002, 'Federal road', 'Bundesstraße' , '''Bundesstraße'' ist eine durch Verwaltungsakt zur Bundesstraße gewidmete Bundesfernstraße.');
INSERT INTO widmung VALUES (1305, 42002, 'National road, state road', 'Landesstraße, Staatsstraße' , '''Landesstraße, Staatsstraße'' ist eine durch Verwaltungsakt zur Landesstraße bzw. Staatsstraße gewidmete Straße.');
INSERT INTO widmung VALUES (1306, 42002, 'District road', 'Kreisstraße' , '''Kreisstraße'' ist eine durch Verwaltungsakt zur Kreisstraße gewidmete Straße.');
INSERT INTO widmung VALUES (1307, 42002, 'Municipal road', 'Gemeindestraße' , '''Gemeindestraße'' ist eine durch Verwaltungsakt zur Gemeindestrasse gewidmete Straße.');
INSERT INTO widmung VALUES (9997, 42002, 'Non-public road', 'Nicht öffentliche Straße' , 'Nicht öffentliche Straße'' bedeutet, dass hier in Straßenverkehr laubt ist, dieser ber nur zweckgebunden, z. B. in einem Krankenhausgelände, durchgeführt wird.');
INSERT INTO widmung VALUES (9999, 42002, 'Other public road', 'Sonstiges öffentliche Straße' , '''Sonstige öffentliche Straße'' bedeutet, dass es sich um eine öffentliche Straße handelt, die aber keiner der vorhandenen Widmung zugewiesen werden kann.');

INSERT INTO widmung VALUES (1310, 44002, 'Waterbodies 1. order - federal waterway', 'Gewässer I. Ordnung - Bundeswasserstraße' , '''Gewässer I. Ordnung - Bundeswasserstraße'' ist ein Gewässer, das der Zuständigkeit des Bundes obliegt.');
INSERT INTO widmung VALUES (1320, 44002, 'Waterbodies 1. order - state waterway', 'Gewässer I. Ordnung - nach Landesrecht' , '''Gewässer I. Ordnung - nach Landesrecht'' ist ein Gewässer, das der Zuständigkeit des Landes obliegt.');
INSERT INTO widmung VALUES (1330, 44002, 'Waterbodies 2. order', 'Gewässer II. Ordnung' , '''Gewässer II. Ordnung'' ist ein Gewässer, für das die Unterhaltungsverbände zuständig sind.');
INSERT INTO widmung VALUES (1340, 44002, 'Waterbodies 3. order', 'Gewässer III. Ordnung' , '''Gewässer III. Ordnung'' ist ein Gewässer, das weder zu den Gewässern I. noch II. Ordnung zählt.');

INSERT INTO widmung VALUES (1310, 44003, 'Waterbodies 1. order - federal waterway', 'Gewässer I. Ordnung - Bundeswasserstraße' , '''Gewässer I. Ordnung - Bundeswasserstraße'' ist ein Gewässer, das der Zuständigkeit des Bundes obliegt.');
INSERT INTO widmung VALUES (1320, 44003, 'Waterbodies 1. order - state waterway', 'Gewässer I. Ordnung - nach Landesrecht' , '''Gewässer I. Ordnung - nach Landesrecht'' ist ein Gewässer, das der Zuständigkeit des Landes obliegt.');
INSERT INTO widmung VALUES (1330, 44003, 'Waterbodies 2. order', 'Gewässer II. Ordnung' , '''Gewässer II. Ordnung'' ist ein Gewässer, für das die Unterhaltungsverbände zuständig sind.');
INSERT INTO widmung VALUES (1340, 44003, 'Waterbodies 3. order', 'Gewässer III. Ordnung' , '''Gewässer III. Ordnung'' ist ein Gewässer, das weder zu den Gewässern I. noch II. Ordnung zählt.');

INSERT INTO widmung VALUES (1310, 44006, 'Waterbodies 1. order - federal waterway', 'Gewässer I. Ordnung - Bundeswasserstraße' , '''Gewässer I. Ordnung - Bundeswasserstraße'' ist ein Gewässer, das der Zuständigkeit des Bundes obliegt.');
INSERT INTO widmung VALUES (1320, 44006, 'Waterbodies 1. order - state waterway', 'Gewässer I. Ordnung - nach Landesrecht' , '''Gewässer I. Ordnung - nach Landesrecht'' ist ein Gewässer, das der Zuständigkeit des Landes obliegt.');
INSERT INTO widmung VALUES (1330, 44006, 'Waterbodies 2. order', 'Gewässer II. Ordnung' , '''Gewässer II. Ordnung'' ist ein Gewässer, für das die Unterhaltungsverbände zuständig sind.');
INSERT INTO widmung VALUES (1340, 44006, 'Waterbodies 3. order', 'Gewässer III. Ordnung' , '''Gewässer III. Ordnung'' ist ein Gewässer, das weder zu den Gewässern I. noch II. Ordnung zählt.');

ALTER TABLE "ver01_l" ADD CONSTRAINT widmung_fk FOREIGN KEY (wdm, objart) REFERENCES widmung(code, objart);

ALTER TABLE "gew01_f" ADD CONSTRAINT widmung_fk FOREIGN KEY (wdm, objart) REFERENCES widmung(code, objart);
ALTER TABLE "gew01_l" ADD CONSTRAINT widmung_fk FOREIGN KEY (wdm, objart) REFERENCES widmung(code, objart);

-- Attribute: zustand
CREATE TABLE zustand (
                         code VARCHAR(4) PRIMARY KEY,
                         name_en TEXT,
                         name_de TEXT,
                         definition_de TEXT,
                         CONSTRAINT check_column_format CHECK (
                             code ~ '^[0-9]{4}$'
                             OR LENGTH(code) = 4
)
    );
INSERT INTO zustand VALUES (1000, 'Officially established', 'Amtlich festgestellt' , '''Amtlich festgestellt'' bedeutet, dass der Zustand für eine dem Natur-, Umwelt- oder Bodenschutzrecht unterliegende Fläche durch eine Verwaltungsstelle festgelegt wird.');
INSERT INTO zustand VALUES (1100, 'In provisional state', 'In behelfsmäßigem Zustand' , '''In behelfsmäßigem Zustand'' bedeutet, dass das Gebäude nur eingeschränkt bewohnt oder genutzt werden kann.');
INSERT INTO zustand VALUES (1200, 'In unused state', 'In ungenutztem Zustand' , '''In ungenutztem Zustand'' bedeutet, dass das Gebäude nicht genutzt wird.');
INSERT INTO zustand VALUES (2000, 'Temporarily established', 'Einstweilig sicher gestellt' , '''Einstweilig sicher gestellt'' bedeutet, dass durch die zuständige Fachbehörde eine dem Natur-, Umwelt- oder Bodenschutzrecht unterliegende Fläche eine Veränderungssperre erlassen wurde.');
INSERT INTO zustand VALUES (2100, 'Out of service, shut down, abandoned', 'Außer Betrieb, stillgelegt, verlassen' , '''Außer Betrieb, stillgelegt, verlassen'' bedeutet, dass sich die Bahnverkehrsanlage nicht mehr in regelmäßiger, der Bestimmung entsprechenden Nutzung befindet.');
INSERT INTO zustand VALUES (2200, 'Dilapidated, destroyed', 'Verfallen, zerstört' , '''Verfallen, zerstört'' bedeutet, dass sich der ursprüngliche Zustand des Gebäudes durch menschliche oder zeitliche Einwirkungen so verändert hat, dass eine Nutzung nicht mehr möglich ist.');
INSERT INTO zustand VALUES (2300, 'Partially destroyed', 'Teilweise zerstört' , '''Teilweise zerstört'' bedeutet, dass sich der ursprüngliche Zustand des Gebäudes durch menschliche oder zeitliche Einwirkungen so verändert hat, dass eine Nutzung nur noch teilweise möglich ist.');
INSERT INTO zustand VALUES (3000, 'Planned and requested', 'Geplant und beantragt' , '''Geplant und beantragt'' bedeutet, dass ein Gebäude geplant und dessen Errichtung beantragt ist.');
INSERT INTO zustand VALUES (4000, 'Under construction', 'Im Bau' , '''Im Bau'' bedeutet, dass sich überwiegende Teile der Bahnverkehrsanlage im Bau befinden.');
INSERT INTO zustand VALUES (4100, 'Disputed/contentious', 'Streitig/strittig' , '''Streitig/strittig'' bedeutet, dass der Grenzverlauf umstritten ist.');
INSERT INTO zustand VALUES (4200, 'Fictitious boundary', 'Grenzverlauf, fiktiv' , '''Grenzverlauf, fiktiv’ bedeutet, dass für den Grenzverlauf des Gebietes keine explizite Grenzgeometrie festgelegt ist.');
INSERT INTO zustand VALUES (5000, 'Wet', 'Nass' , '''Nass'' bezeichnet eine Vegetationsfläche, die aufgrund besonderer Bodenbeschaffenheit ganzjährig wassergesättigt ist, zeitweise auch unter Wasser stehen kann.');
INSERT INTO zustand VALUES (6100, 'Forest regeneration, new planting area', 'Waldverjüngungs-, Neuanpflanzungsfläche' , '''Waldverjüngungs-, Neuanpflanzungsfläche'' bedeutet, dass sich der Wald durch Aufforstung, Naturverjüngung oder durch Anpflanzung neu bildet.');
INSERT INTO zustand VALUES (8000, 'Expansion, new settlement', 'Erweiterung, Neuansiedlung' , '''Erweiterung, Neuansiedlung'' bedeutet, dass die Fläche in ihrer Nutzung gemäß der Objektart erweitert wird und eine Fertigstellung absehbar ist.');

ALTER TABLE "sie02_f" ADD CONSTRAINT zustand_fk FOREIGN KEY (zus) REFERENCES zustand(code);
ALTER TABLE "sie03_f" ADD CONSTRAINT zustand_fk FOREIGN KEY (zus) REFERENCES zustand(code);
ALTER TABLE "sie03_p" ADD CONSTRAINT zustand_fk FOREIGN KEY (zus) REFERENCES zustand(code);
ALTER TABLE "sie04_l" ADD CONSTRAINT zustand_fk FOREIGN KEY (zus) REFERENCES zustand(code);
ALTER TABLE "sie04_p" ADD CONSTRAINT zustand_fk FOREIGN KEY (zus) REFERENCES zustand(code);
ALTER TABLE "sie05_p" ADD CONSTRAINT zustand_fk FOREIGN KEY (zus) REFERENCES zustand(code);
ALTER TABLE "ver01_l" ADD CONSTRAINT zustand_fk FOREIGN KEY (zus) REFERENCES zustand(code);
ALTER TABLE "ver03_l" ADD CONSTRAINT zustand_fk FOREIGN KEY (zus) REFERENCES zustand(code);
ALTER TABLE "ver04_f" ADD CONSTRAINT zustand_fk FOREIGN KEY (zus) REFERENCES zustand(code);
ALTER TABLE "ver06_f" ADD CONSTRAINT zustand_fk FOREIGN KEY (zus) REFERENCES zustand(code);
ALTER TABLE "ver06_l" ADD CONSTRAINT zustand_fk FOREIGN KEY (zus) REFERENCES zustand(code);
ALTER TABLE "ver06_p" ADD CONSTRAINT zustand_fk FOREIGN KEY (zus) REFERENCES zustand(code);
ALTER TABLE "veg04_f" ADD CONSTRAINT zustand_fk FOREIGN KEY (zus) REFERENCES zustand(code);
ALTER TABLE "gew01_f" ADD CONSTRAINT zustand_fk FOREIGN KEY (zus) REFERENCES zustand(code);
ALTER TABLE "gew01_l" ADD CONSTRAINT zustand_fk FOREIGN KEY (zus) REFERENCES zustand(code);
ALTER TABLE "geb01_l" ADD CONSTRAINT zustand_fk FOREIGN KEY (zus) REFERENCES zustand(code);


-- Attribute: bauwerksfunktion
CREATE TABLE bauwerksfunktion (
    code VARCHAR(4),
    objart VARCHAR(5),
    name_en TEXT,
    name_de TEXT,
    definition_de TEXT,
    PRIMARY KEY (code, objart),
    CONSTRAINT check_column_format CHECK (
        code ~ '^[0-9]{4}$'
        OR LENGTH(code) = 4
                              )
    );

INSERT INTO bauwerksfunktion VALUES (1001, 51001, 'Water tower', 'Wasserturm' , '''Wasserturm'' ist ein hochgelegenes Bauwerk mit einem Behälter, in dem Wasser für die Wasserversorgung und Konstanthaltung des Wasserdruckes gespeichert wird.');
INSERT INTO bauwerksfunktion VALUES (1002, 51001, 'Church tower, bell tower', 'Kirchturm, Glockenturm' , '''Kirchturm, Glockenturm'' ist ein freistehender Turm, der die Glockenstube mit den Glocken aufnimmt.');
INSERT INTO bauwerksfunktion VALUES (1003, 51001, 'Observation tower', 'Aussichtsturm' , '''Aussichtsturm'' ist ein Bauwerk, das ausschließlich der Fernsicht dient.');
INSERT INTO bauwerksfunktion VALUES (1004, 51001, 'Control tower', 'Kontrollturm' , '''Kontrollturm'' (Tower) ist ein Bauwerk auf dem Fluggelände, in dem die für die Lenkung und Überwachung des Flugverkehrs erforderlichen Anlagen und Einrichtungen untergebracht sind.');
INSERT INTO bauwerksfunktion VALUES (1005, 51001, 'Cooling tower', 'Kühlturm' , '''Kühlturm'' ist eine turmartige Kühlanlage (Nass- oder Trockenkühlturm), in der erwärmtes Kühlwasser insbesondere von Kraftwerken rückgekühlt wird.');
INSERT INTO bauwerksfunktion VALUES (1006, 51001, 'Lighthouse', 'Leuchtturm' , '''Leuchtturm'' ist ein als Schifffahrtszeichen erirchteter hoher Turm.');
INSERT INTO bauwerksfunktion VALUES (1007, 51001, 'Fire station tower', 'Feuerwachturm' , '''Feuerwachturm'' ist ein Turm, der zum Erkennen von Gefahren (Feuer) dient.');
INSERT INTO bauwerksfunktion VALUES (1008, 51001, 'Transmission tower, radio tower, telecommunications tower', 'Sende-, Funkturm, Fernmeldeturm' , '''Sende-, Funkturm, Fernmeldeturm''’ ist ein Bauwerk, ausgerüstet mit Sende - und Empfangsantennen zum Übertragen und Empfangen von Nachrichten aller Arten von Telekommunikation.');
INSERT INTO bauwerksfunktion VALUES (1009, 51001, 'City tower, gate tower', 'Stadt-, Torturm' , '''Stadtturm'' ist ein historischer Turm, der das Stadtbild prägt. ''Torturm'' ist der auf einem Tor stehende Turm, wobei das Tor allein stehen oder in eine Befestigungsanlage eingebunden sein kann.');
INSERT INTO bauwerksfunktion VALUES (1010, 51001, 'Pithead tower', 'Förderturm' , '''Förderturm'' ist ein Turm über einem Schacht. An Förderseile, die über Seilscheiben im Turm geführt werden, werden Lasten in den Schacht gesenkt oder aus dem Schacht gehoben.');
INSERT INTO bauwerksfunktion VALUES (1011, 51001, 'Drilling rig', 'Bohrturm' , '''Bohrturm'' ist ein zur Gewinnung von Erdöl, Erdgas oder Sole verwendetes, meist aus einer Stahlkonstruktion bestehendes Gerüst, in dem das Bohrgestänge aufgehängt ist.');
INSERT INTO bauwerksfunktion VALUES (1012, 51001, 'Castle tower', 'Schloss-, Burgturm' , '''Schloss-, Burgturm'' ist ein Turm innerhalb einer Schloss- bzw. einer Burganlage, auch Bergfried genannt.');
INSERT INTO bauwerksfunktion VALUES (9998, 51001, 'Not specified according to sources', 'Nach Quellenlage nicht zu spezifizieren' , '''Nach Quellenlage nicht zu spezifizieren'' bedeutet, dass zum Zeitpunkt der Erhebung keine Funktion zuweisbar war.');
INSERT INTO bauwerksfunktion VALUES (9999, 51001, 'Other', 'Sonstiges' , '''Sonstiges'' bedeutet, dass die Funktion bekannt, aber nicht in der Attributwertliste aufgeführt ist.');

INSERT INTO bauwerksfunktion VALUES (1110, 51005, 'Overhead cable', 'Freileitung' , '''Freileitung'' ist eine aus einem oder mehreren Drähten oder Fasern hergestellte oberirdische Leitung zum Transport von elektrischer Energie und zur Übertragung von elektrischen Signalen.');
INSERT INTO bauwerksfunktion VALUES (1111, 51005, 'Underground cable', 'Erdkabel' , '''Erdkabel'' ist eine aus einem oder mehreren Drähten oder Fasern hergestellte unterirdische Leitung zum Transport von elektrischer Energie und/oder zur Übertragung von elektrischen Signalen.');

INSERT INTO bauwerksfunktion VALUES (1101, 51004, 'Pipeline', 'Rohrleitung, Pipeline' , '''Rohrleitung, Pipeline'' ist ein langgestreckter Hohlkörper zum Transport von Flüssigkeiten und Gasen.');
INSERT INTO bauwerksfunktion VALUES (1102, 51004, 'Conveyor belt', 'Förderband, Bandstraße' , '''Förderband, Bandstraße'' ist ein mechanisch bewegtes Band zum Transport von Gütern.');
INSERT INTO bauwerksfunktion VALUES (1103, 51004, 'Pump', 'Pumpe' , '''Pumpe'' ist eine Vorrichtung zum An-, Absaugen oder Injizieren von Flüssigkeiten oder Gasen; Verdichtungsstation für Gase.');

INSERT INTO bauwerksfunktion VALUES (1201, 51003, 'Silo', 'Silo' , '''Silo'' ist ein Großraumbehälter zum Speichern von Schüttgütern (Getreide, Erz, Zement, Sand) oder Gärfutter (gehäckseltes Grüngut).');
INSERT INTO bauwerksfunktion VALUES (1202, 51003, 'Filling hopper', 'Fülltrichter' , '');
INSERT INTO bauwerksfunktion VALUES (1203, 51003, 'Bunker', 'Bunker' , '''Bunker'' ist ein Bauwerk, in dem Schüttgut gelagert wird.');
INSERT INTO bauwerksfunktion VALUES (1204, 51003, 'Grain elevator', 'Getreideheber' , '');
INSERT INTO bauwerksfunktion VALUES (1205, 51003, 'Tank', 'Tank' , '''Tank'' ist ein Behälter, in dem Flüssigkeiten gelagert oder Gase gespeichert werden.');
INSERT INTO bauwerksfunktion VALUES (1206, 51003, 'Gasometer', 'Gasometer' , '''Gasometer'' ist ein volumenveränderbarer Niederdruckbehälter für Gas.');
INSERT INTO bauwerksfunktion VALUES (9999, 51003, 'Other', 'Sonstiges' , '''Sonstiges'' bedeutet, dass die Funktion bekannt, aber nicht in der Attributwertliste aufgeführt ist.');

INSERT INTO bauwerksfunktion VALUES (1210, 51002, 'Clarifier', 'Klärbecken' , '''Klärbecken'' ist ein künstlich errichtetes Becken oder eine Geländevertiefung, in der Feststoffe aus einer Flüssigkeit ausgefällt werden.');
INSERT INTO bauwerksfunktion VALUES (1215, 51002, 'Biogas plant', 'Biogasanlage' , '''Biogasanlage'' ist eine Anlage, in der aus Biomasse Gas erzeugt wird.');
INSERT INTO bauwerksfunktion VALUES (1220, 51002, 'Wind turbine', 'Windrad' , '''Windrad'' ist ein mit Flügeln besetztes Rad, das durch Wind in Rotation versetzt wird und mit Hilfe eines eingebauten Generators elektrische Energie erzeugt.');
INSERT INTO bauwerksfunktion VALUES (1230, 51002, 'Solar panel', 'Solarzellen' , '''Solarzellen'' sind Flächenelemente aus Halbleitern, die die Energie der Sonnenstrahlen in elektrische Energie umwandeln.');
INSERT INTO bauwerksfunktion VALUES (1240, 51002, 'Waterwheel', 'Wasserrad' , '''Wasserrad'' ist ein mit Schaufeln oder Zellen besetztes Rad, das die Energie des strömenden Wassers zum Antrieb, besonders von Mühlen, ausnutzt oder zum Schöpfen von Wasser (Schöpfrad) genutzt wird.');
INSERT INTO bauwerksfunktion VALUES (1250, 51002, 'Mast', 'Mast' , '''Mast'' ist eine senkrecht stehende Konstruktion mit stützender oder tragender Funktion.');
INSERT INTO bauwerksfunktion VALUES (1251, 51002, 'Overhead pylon', 'Freileitungsmast' , '''Freileitungsmast'' ist ein Mast, an dem Hochspannungsleitungen befestigt sind.');
INSERT INTO bauwerksfunktion VALUES (1260, 51002, 'Radio tower', 'Funkmast' , '''Funkmast'' ist ein Mast mit Vorrichtungen zum Empfangen, Umformen und Weitersenden von elektromagnetischen Wellen.');
INSERT INTO bauwerksfunktion VALUES (1270, 51002, 'Antenna', 'Antenne' , '''Antenne'' ist eine Vorrichtung zum Empfang oder zur Ausstrahlung elektromagnetischer Wellen.');
INSERT INTO bauwerksfunktion VALUES (1275, 51002, 'Radio navigation system', 'Funknavigationsanlage' , '''Funknavigationsanlage'' ist eine Vorrichtung zur Verkehrssicherung.');
INSERT INTO bauwerksfunktion VALUES (1280, 51002, 'Radio telescope', 'Radioteleskop' , '''Radioteleskop'' ist ein Bauwerk mit einer Parabolantenne für den Empfang und/oder das Senden von elektromagnetischer Strahlung aus dem/in das Weltall.');
INSERT INTO bauwerksfunktion VALUES (1290, 51002, 'Chimney', 'Schornstein' , '''Schornstein'' ist ein freistehend senkrecht hochgeführter Abzugskanal für die Rauchgase einer Feuerungsanlage oder für andere Abgase.');
INSERT INTO bauwerksfunktion VALUES (1310, 51002, 'Tunnel mouth', 'Stollenmundloch' , '''Stollenmundloch'' ist der Eingang eines unterirdischen Gangs, der annähernd horizontal von der Erdoberfläche in das Gebirge führt.');
INSERT INTO bauwerksfunktion VALUES (1320, 51002, 'Shaft opening', 'Schachtöffnung' , '''Schachtöffnung'' ist der Eingang auf der Erdoberfläche zu einem Schacht.');
INSERT INTO bauwerksfunktion VALUES (1330, 51002, 'Crane', 'Kran' , '''Kran'' ist eine Vorrichtung, die aus einer fahrbaren oder ortsfesten Konstruktion besteht und die zum Heben von Lasten benutzt wird.');
INSERT INTO bauwerksfunktion VALUES (1331, 51002, 'Slewing crane', 'Drehkran' , '');
INSERT INTO bauwerksfunktion VALUES (1332, 51002, 'Gantry crane', 'Portalkran' , '');
INSERT INTO bauwerksfunktion VALUES (1333, 51002, 'Overhead travelling crane, bridge travelling crane', 'Laufkran, Brückenlaufkran' , '');
INSERT INTO bauwerksfunktion VALUES (1340, 51002, 'Dry dock', 'Trockendock' , '''Trockendock'' ist eine Anlage in Werften und Häfen, in der das Schiff zum Ausbessern aus dem Wasser genommen wird.');
INSERT INTO bauwerksfunktion VALUES (1350, 51002, 'Furnace', 'Hochofen' , '''Hochofen'' ist ein hoher Schachtofen zum Schmelzen von Eisenerz.');
INSERT INTO bauwerksfunktion VALUES (1360, 51002, 'Marker, marker stone', 'Merkzeichen, Merkstein' , '');
INSERT INTO bauwerksfunktion VALUES (1370, 51002, 'Hydrant', 'Hydrant' , '');
INSERT INTO bauwerksfunktion VALUES (1371, 51002, 'Above-ground hydrant', 'Oberflurhydrant' , '');
INSERT INTO bauwerksfunktion VALUES (1372, 51002, 'Underground hydrant', 'Unterflurhydrant' , '');
INSERT INTO bauwerksfunktion VALUES (1380, 51002, 'Sliding cap', 'Schieberkappe' , '');
INSERT INTO bauwerksfunktion VALUES (1390, 51002, 'Access shaft', 'Einsteigeschacht' , '');
INSERT INTO bauwerksfunktion VALUES (1400, 51002, 'Transformer', 'Umformer' , '');
INSERT INTO bauwerksfunktion VALUES (1700, 51002, 'Mining operation', 'Bergbaubetrieb' , '''Bergbaubetrieb'' ist eine Fläche, die für die Förderung des Abbaugutes unter Tage genutzt wird');
INSERT INTO bauwerksfunktion VALUES (9999, 51002, 'Other', 'Sonstiges' , '''Sonstiges'' bedeutet, dass die Funktion bekannt, aber nicht in der Attributwertliste aufgeführt ist.');
INSERT INTO bauwerksfunktion VALUES (2530, 51002, 'Power station', 'Kraftwerk' , '''Kraftwerk'' bezeichnet eine Fläche mit Bauwerken und sonstigen Einrichtungen zur Erzeugung von elektrischer Energie.');

INSERT INTO bauwerksfunktion VALUES (1410, 51006, 'Pitch', 'Spielfeld' , '''Spielfeld'' ist eine abgegrenzte, markierte Fläche, auf der die Sportart unmittelbar ausgeübt wird, z.B. die einzelnen Fußballfelder (Hauptplatz und Trainingsplätze) einer größeren Anlage oder die Trainings-/Reitplätze i. V. m. Reitsport. Die zusammenhängenden Spielflächen innerhalb einer Tennisanlage werden zu einem Spielfeld zusammengefasst.');
INSERT INTO bauwerksfunktion VALUES (1411, 51006, 'Transformer', 'Hartplatz' , '');
INSERT INTO bauwerksfunktion VALUES (1412, 51006, 'Transformer', 'Rasenplatz' , '');
INSERT INTO bauwerksfunktion VALUES (1420, 51006, 'Racecourse, running track, track', 'Rennbahn, Laufbahn, Geläuf' , '''Rennbahn, Laufbahn, Geläuf'' ist eine je nach Art des Rennens verschiedenartig gestaltete Strecke (oval, gerade, kurvig), auf der das Rennen stattfindet.');
INSERT INTO bauwerksfunktion VALUES (1431, 51006, 'Spectator grandstand, roofed', 'Zuschauertribüne, überdacht' , '''Zuschauertribüne, überdacht'' bedeutet, dass ''Zuschauertribüne'' mit einer Dachfläche ausgestattet ist.');
INSERT INTO bauwerksfunktion VALUES (1432, 51006, 'Spectator grandstand, not roofed', 'Zuschauertribüne, nicht überdacht' , '''Zuschauertribüne, nicht überdacht'' bedeutet, dass die Zuschauertribüne keine Dachfläche besitzt.');
INSERT INTO bauwerksfunktion VALUES (1440, 51006, 'Stadium', 'Stadion' , '''Stadion'' ist ein Bauwerk mit Tribünen und entsprechenden Einrichtungen, das vorwiegend zur Ausübung von bestimmten Sportarten dient.');
INSERT INTO bauwerksfunktion VALUES (1441, 51006, 'Stadium, roofed', 'Stadion, überdacht' , '''Stadion, überdacht'' ist ein Bauwerk mit Tribünen und entsprechenden Einrichtungen, das vorwiegend zur Ausübung von bestimmten Sportarten dient und ganz oder nahezu ganz überdacht ist.');
INSERT INTO bauwerksfunktion VALUES (1442, 51006, 'Stadium, not roofed', 'Stadion, nicht überdacht' , '''Stadion, nicht überdacht'' ist ein Bauwerk mit Tribünen und entsprechenden Einrichtungen, das vorwiegend zur Ausübung von bestimmten Sportarten dient, aber ohne Dachflächen ist.');
INSERT INTO bauwerksfunktion VALUES (1450, 51006, 'Swimming pool', 'Schwimmbecken' , '''Schwimmbecken'' ist ein mit Wasser gefülltes Becken zum Schwimmen oder Baden.');
INSERT INTO bauwerksfunktion VALUES (1470, 51006, 'Ski jump (inrun)', 'Sprungschanze (Anlauf)' , '''Sprungschanze (Anlauf)'' ist eine Anlage zum Skispringen mit einer stark abschüssigen, in einem Absprungtisch endenden Bahn zum Anlauf nehmen.');
INSERT INTO bauwerksfunktion VALUES (1480, 51006, 'Shooting range', 'Schießanlage' , '''Schießanlage'' ist eine Anlage mit Schießbahnen für Schießübungen oder sportliche Wettbewerbe.');
INSERT INTO bauwerksfunktion VALUES (1490, 51006, 'Graduation tower', 'Gradierwerk' , '''Gradierwerk'' ist ein mit Reisig bedecktes Gerüst, über das Sole rieselt, die durch erhöhte Verdunstung konzentriert wird.');
INSERT INTO bauwerksfunktion VALUES (1510, 51006, 'Wildlife enclosure', 'Wildgehege' , '''Wildgehege'' ist ein eingezäuntes Areal, in dem Wild waidgerecht betreut wird oder beobachtet werden kann.');
INSERT INTO bauwerksfunktion VALUES (1610, 51006, 'Zoo', 'Zoo' , '''Zoo'' ist ein Gelände mit Tierschauhäusern und umzäunten Gehegen, auf dem Tiere gehalten und gezeigt werden.');
INSERT INTO bauwerksfunktion VALUES (1620, 51006, 'Safari park, game park', 'Safaripark, Wildpark' , '''Safaripark, Wildpark'', ist ein Gelände mit umzäunten Gehegen, in denen Tiere im Freien gehalten und gezeigt werden.');
INSERT INTO bauwerksfunktion VALUES (1630, 51006, 'Amusement park', 'Freizeitpark' , '''Freizeitpark'' ist ein Gelände mit Karussells, Verkaufs- und Schaubuden und/oder Wildgattern, das der Freizeitgestaltung dient.');
INSERT INTO bauwerksfunktion VALUES (1640, 51006, 'Open-air theatre', 'Freilichtbühne' , '''Freilichtbühne'' ist ein Anlage mit Bühnen und Zuschauerbänken für Aufführungen im Freien.');
INSERT INTO bauwerksfunktion VALUES (1650, 51006, 'Watersports centre', 'Wassersportanlage' , '''Wassersportanlage'' bezeichnet ein Areal welches beispielsweise zum Rudern, Segeln oder für Wasserski genutzt wird.');
INSERT INTO bauwerksfunktion VALUES (9999, 51006, 'Other', 'Sonstiges' , '''Sonstiges'' bedeutet, dass die Funktion bekannt, aber nicht in der Attributwertliste aufgeführt ist.');

INSERT INTO bauwerksfunktion VALUES (1610, 51009, 'Canopy', 'Überdachung' , 'Überdachungen sind i. d. R. an allen Seiten offen. Eine geschlossene Seite kann über eine besondere Gebäudelinie mit der Werteart ''Geschlossene Seite einer Überdachung'' nachgewiesen werden.');
INSERT INTO bauwerksfunktion VALUES (1611, 51009, 'Carport', 'Carport' , 'Carports sind i. d. R. an allen Seiten offen. Eine geschlossene Seite kann über eine besondere Gebäudelinie mit der Werteart ''Geschlossene Seite einer Überdachung'' nachgewiesen werden.');
INSERT INTO bauwerksfunktion VALUES (1620, 51009, 'Staircase', 'Treppe' , '''Treppe'' ist ein stufenförmiges Bauwerk zur Überwindung von Höhenunterschieden.');
INSERT INTO bauwerksfunktion VALUES (1621, 51009, 'Open staircase', 'Freitreppe' , '');
INSERT INTO bauwerksfunktion VALUES (1622, 51009, 'Escalator', 'Rolltreppe' , '');
INSERT INTO bauwerksfunktion VALUES (1630, 51009, 'Bottom edge of stairs', 'Treppenunterkante' , '');
INSERT INTO bauwerksfunktion VALUES (1640, 51009, 'Cellar entrance', 'Kellereingang' , '''Kellereingang'' ist der Eingang zu einem unterirdischen Vorratsraum außerhalb von Gebäuden.');
INSERT INTO bauwerksfunktion VALUES (1641, 51009, 'Cellar entrance, open', 'Kellereingang, offen' , '''Kellereingang, offen'' ist der offene Eingang zu einem unterirdischen Vorratsraum außerhalb von Gebäuden.');
INSERT INTO bauwerksfunktion VALUES (1642, 51009, 'Cellar entrance, closed', 'Kellereingang, geschlossen' , '''Kellereingang, geschlossen'' ist der geschlossene Eingang zu einem unterirdischen Vorratsraum außerhalb von Gebäuden.');
INSERT INTO bauwerksfunktion VALUES (1650, 51009, 'Ramp', 'Rampe' , '');
INSERT INTO bauwerksfunktion VALUES (1670, 51009, 'Terrace', 'Terrasse' , 'Es werden nur unterkellerte Terrassen erfasst.');
INSERT INTO bauwerksfunktion VALUES (1700, 51009, 'Wall', 'Mauer' , '''Mauer'' ist ein freistehendes, langgestrecktes Bauwerk, das aus Natur- bzw. Kunststeinen oder anderen Materialien besteht.');
INSERT INTO bauwerksfunktion VALUES (1701, 51009, 'Wall edge, right', 'Mauerkante, rechts' , '');
INSERT INTO bauwerksfunktion VALUES (1702, 51009, 'Wall edge, left', 'Mauerkante, links' , '');
INSERT INTO bauwerksfunktion VALUES (1703, 51009, 'Wall centre', 'Mauermitte' , '');
INSERT INTO bauwerksfunktion VALUES (1720, 51009, 'Support wall', 'Stützmauer' , '''Stützmauer'' ist eine zum Stützen von Erdreich dienende Mauer.');
INSERT INTO bauwerksfunktion VALUES (1721, 51009, 'Support wall, right', 'Stützmauer, rechts' , '');
INSERT INTO bauwerksfunktion VALUES (1722, 51009, 'Support wall, left', 'Stützmauer, links' , '');
INSERT INTO bauwerksfunktion VALUES (1723, 51009, 'Support wall centre', 'Stützmauermitte' , '');
INSERT INTO bauwerksfunktion VALUES (1740, 51009, 'Fence', 'Zaun' , '''Zaun'' ist eine Abgrenzung oder Einfriedung aus Holz- oder Metallstäben oder aus Draht bzw. Drahtgeflecht.');
INSERT INTO bauwerksfunktion VALUES (1750, 51009, 'Memorial, monument, memorial stone, statue', 'Gedenkstätte, Denkmal, Denkstein, Standbild' , '''Gedenkstätte, Denkmal, Denkstein, Standbild'' ist ein zum Gedenken errichtete Anlage oder Bauwerk an eine Person, ein Ereignis oder eine plastische Darstellung.');
INSERT INTO bauwerksfunktion VALUES (1760, 51009, 'Wayside shrine, wayside cross, summit cross', 'Bildstock, Wegekreuz, Gipfelkreuz' , '''Bildstock, Wegekreuz, Gipfelkreuz'' ist ein frei stehendes Mal aus Holz oder Stein, das in einem tabernakelartigen Aufbau ein Kruzifix oder eine Heiligendarstellung enthält und als Andachtsbild, als Erinnerung an Verstorbene oder als Sühnemal errichtet wurde; ist ein errichtetes Kreuz z.B. an Wegen; ist ein Kreuz auf dem Gipfel eines Berges.');
INSERT INTO bauwerksfunktion VALUES (1761, 51009, 'Wayside shrine', 'Bildstock' , '');
INSERT INTO bauwerksfunktion VALUES (1762, 51009, 'Wayside cross', 'Wegekreuz' , '');
INSERT INTO bauwerksfunktion VALUES (1763, 51009, 'Summit cross', 'Gipfelkreuz' , '');
INSERT INTO bauwerksfunktion VALUES (1770, 51009, 'Milestone, historical boundary stone', 'Meilenstein, historischer Grenzstein' , '''Meilenstein, historischer Grenzstein'' sind Steine von kulturgeschichtlicher Bedeutung, die am Rande von Verkehrswegen aufgestellt sind und Entfernungen in unterschiedlichenMaßeinheiten (z. B. Meilen, Kilometer oder Stunden) angeben oder als Grenzsteine vergangene Eigentumsverhältnisse dokumentieren.');
INSERT INTO bauwerksfunktion VALUES (1780, 51009, 'Fountain', 'Brunnen' , '''Brunnen'' ist eine Anlage zur Gewinnung von Grundwasser bzw. ein architektonisch ausgestaltetes Bauwerk mit Becken zum Auffangen von Wasser.');
INSERT INTO bauwerksfunktion VALUES (1781, 51009, 'Well (drinking water supply)', 'Brunnen (Trinkwasserversorgung)' , '''Brunnen (Trinkwasserversorgung)'' bedeutet, dass in dem Brunnen ausschließlich Trinkwasser gewonnen wird.');
INSERT INTO bauwerksfunktion VALUES (1782, 51009, 'Fountains, ornamental fountains', 'Springbrunnen, Zierbrunnen' , '');
INSERT INTO bauwerksfunktion VALUES (1783, 51009, 'Drawing well', 'Ziehbrunnen' , '');
INSERT INTO bauwerksfunktion VALUES (1790, 51009, 'Sheet pile wall', 'Spundwand' , '''Spundwand'' ist ein Sicherungsbauwerk (wasserdichte Wand) aus miteinander verbundenen schmalen, langen Holz-, Stahl- oder Stahlbetonbohlen zum Schutz gegen das Außenwasser. Die Bohlen werden horizontal hinter Pfählen (Bohlwand) oder vertikal als Spundwand eingebaut und meist rückwärtig verankert.');
INSERT INTO bauwerksfunktion VALUES (1791, 51009, 'Hump line', 'Höckerlinie' , '''Höckerlinie'' bezeichnet die ehemalige Panzersperre Westwall.');
INSERT INTO bauwerksfunktion VALUES (9999, 51009, 'Other', 'Sonstiges' , '''Sonstiges'' bedeutet, dass die Funktion bekannt, aber nicht in der Attributwertliste aufgeführt ist.');

INSERT INTO bauwerksfunktion VALUES (1800, 53001, 'Bridge', 'Brücke' , '''Brücke'' ist ein Bauwerk, das einen Verkehrsweges über, ein Gewässer oder einen Tierpfad (Grünbrücke) über ein natürliches oder künstliches Hindernis führt.');
INSERT INTO bauwerksfunktion VALUES (1801, 53001, 'Multi-level bridge', 'Mehrstöckige Brücke' , '''Mehrstöckige Brücke'' ist eine Brücke, die mit Verkehrswegen in mehreren Etagen ausgestattet ist.');
INSERT INTO bauwerksfunktion VALUES (1802, 53001, 'Arch bridge', 'Bogenbrücke' , '''Bogenbrücke'' ist eine Brücke, bei der das Tragwerk aus Bögen besteht.');
INSERT INTO bauwerksfunktion VALUES (1803, 53001, 'Truss bridge', 'Fachwerkbrücke' , '''Fachwerkbrücke'' ist eine Brücke, bei der das Tragwerk aus starr zusammengesetzten Tragbalken (Holz oder Metall) besteht.');
INSERT INTO bauwerksfunktion VALUES (1804, 53001, 'Suspension bridge', 'Hängebrücke' , '''Hängebrücke'' ist eine Brücke, bei der das Tragwerk von Hängegurten (Kabel) an einem oder mehreren Pylonen gehalten wird.');
INSERT INTO bauwerksfunktion VALUES (1805, 53001, 'Pontoon bridge', 'Pontonbrücke' , '''Pontonbrücke'' ist eine Behelfsbrücke, die sich aus kastenförmigen Schwimmkörpern zusammensetzt.');
INSERT INTO bauwerksfunktion VALUES (1806, 53001, 'Swing bridge', 'Drehbrücke' , '''Drehbrücke'' ist eine Brücke, bei der sich das Tragwerk um einen senkrechten Zapfen (Königsstuhl) dreht.');
INSERT INTO bauwerksfunktion VALUES (1807, 53001, 'Lifting bridge', 'Hebebrücke' , '''Hebebrücke'' ist eine Brücke, bei der das Tragwerk an Seilen oder Ketten emporgehoben wird.');
INSERT INTO bauwerksfunktion VALUES (1808, 53001, 'Drawbridge', 'Zugbrücke' , '''Zugbrücke'' ist eine Brücke, bei der das Tragwerk um eine waagerechte Achse hochgeklappt wird.');
INSERT INTO bauwerksfunktion VALUES (1810, 53001, 'Walkway', 'Steg' , '''Steg'' ist eine kleine Brücke ein facher Bauart.');
INSERT INTO bauwerksfunktion VALUES (1820, 53001, 'Landing bridge', 'Landebrücke' , '');
INSERT INTO bauwerksfunktion VALUES (1830, 53001, 'Elevated railway, elevated road', 'Hochbahn, Hochstraße' , '''Hochbahn, Hochstraße'' ist ein brückenartiges, aufgeständertes Verkehrsbauwerk.');
INSERT INTO bauwerksfunktion VALUES (1840, 53001, 'Bridge piers', 'Brückenpfeiler' , '');
INSERT INTO bauwerksfunktion VALUES (1845, 53001, 'Abutment', 'Widerlager' , '');
INSERT INTO bauwerksfunktion VALUES (1850, 53001, 'Power pillar', 'Strompfeiler' , '');
INSERT INTO bauwerksfunktion VALUES (1870, 53001, 'Tunnel, underpass', 'Tunnel, Unterführung' , '''Tunnel, Unterführung'' ist ein künstlich angelegtes unterirdisches Bauwerk, das im Verlauf von Verkehrswegen durch Bergmassive oder unter Flussläufen, Meerengen, städt. Bebauungen u. a. hindurchführt.');
INSERT INTO bauwerksfunktion VALUES (1880, 53001, 'Protective gallery, enclosure', 'Schutzgalerie, Einhausung' , '''Schutzgalerie, Einhausung'' ist eine bauliche Einrichtung an Verkehrswegen zum Schutz gegen Lawinen, Schneeverwehungen, Steinschlägen sowie zum Schutz gegen Emission. Schutzgalerien sind einseitige Überbauungen an Verkehrswegen, Einhausungen umschließen die Verkehrswege meist vollständig.');
INSERT INTO bauwerksfunktion VALUES (1890, 53001, 'Lock chamber', 'Schleusenkammer' , '''Schleusenkammer'' ist eine Einrichtung zur Überführung von Wasserfahrzeugen zwischen Gewässern mit unterschiedlichen Wasserspiegelhöhen.');
INSERT INTO bauwerksfunktion VALUES (1900, 53001, 'Passageway', 'Durchfahrt' , '''Durchfahrt'' ist eine Stelle, an der mit Fahrzeugen durch ein Bauwerk (z.B. ein Turm, eine Mauer) hindurch gefahren werden kann.');
INSERT INTO bauwerksfunktion VALUES (1910, 53001, 'Approach lighting', 'Anflugbefeuerung' , '');
INSERT INTO bauwerksfunktion VALUES (9999, 53001, 'Other', 'Sonstiges' , '''Sonstiges'' bedeutet, dass die Funktion bekannt, aber nicht in der Attributwertliste aufgeführt ist.');

INSERT INTO bauwerksfunktion VALUES (2010, 53009, 'Culvert', 'Durchlass' , '''Durchlass'' ist ein Bauwerk, in dem ein Gewässer unter einem auf der Erdoberfläche liegenden Hindernis (Verkehrsweg, Siedlungsfläche) hindurchgeführt wird oder unter der Erdoberfläche in freier Feldlage oder abgedeckt (verdolt) auf der Erdoberfläche verläuft.');
INSERT INTO bauwerksfunktion VALUES (2011, 53009, 'Pipe culvert', 'Rohrdurchlass' , '''Rohrdurchlass'' ist ein Bauwerk zur Unterführung eines Gewässers unter einem Verkehrsweg.');
INSERT INTO bauwerksfunktion VALUES (2012, 53009, 'Düker', 'Düker' , '''Düker'' ist ein Kreuzungsbauwerk, in dem ein Gewässer unter einem anderen Gewässer, einem Geländeeinschnitt oder einem tieferliegenden Hindernis unter Druck hindurchgeleitet wird.');
INSERT INTO bauwerksfunktion VALUES (2013, 53009, 'Water tunnel, pressure tunnel', 'Wassertunnel, Wasserstollen, Druckstollen' , '''Wassertunnel, Wasserstollen, Druckstollen'' ist ein in einen Berg oder Hügel getriebener unterirdischer Tunnel (Stollen), durch den Wasser hindurchgeführt wird. Dabei fließt das Wasser in einem Wassertunnel bzw. Wasserstollen in Richtung des gebauten Gefälles. In einem Druckstollen, der als Wasserleitung genutzt wird, baut sich durch die vollständige Füllung des Stollens ein hydrostatischer Wasserdruck auf, so dass das Wasser auch ansteigende Abschnitte überwinden kann.');
INSERT INTO bauwerksfunktion VALUES (2020, 53009, 'Retention basin', 'Rückhaltebecken' , '''Rückhaltebecken'' ist ein natürliches oder künstlich angelegtes Becken, ggf. mit Bauwerken und Einrichtungen, zur vorübergehenden Speicherung großer Wassermengen.');
INSERT INTO bauwerksfunktion VALUES (2030, 53009, 'Dam wall', 'Staumauer' , '''Staumauer'' ist ein aus Mauerwerk oder Beton bestehendes Absperrbauwerk zur Erzeugung eines Staus.');
INSERT INTO bauwerksfunktion VALUES (2040, 53009, 'Embankment dam', 'Staudamm' , '''Staudamm'' ist ein meist aus natürlichen Baustoffen, meist aufgeschüttetes Absperrbauwerk zur Erzeugung eines Staus.');
INSERT INTO bauwerksfunktion VALUES (2050, 53009, 'Weir', 'Wehr' , '''Wehr'' ist ein festes oder mit beweglichen Teilen ausgestattetes Bauwerk im Gewässerbereich zur Regulierung des Wasserabflusses.');
INSERT INTO bauwerksfunktion VALUES (2060, 53009, 'Security gate', 'Sicherheitstor' , '''Sicherheitstor'' ist ein Bauwerk zum Abschließen von Kanalstrecken, um bei Schäden das Auslaufen der gesamten Kanalhaltung zu verhindern.');
INSERT INTO bauwerksfunktion VALUES (2070, 53009, 'Siel', 'Siel' , '''Siel'' ist ein Bauwerk mit Verschlusseinrichtung (gegen rückströmendes Wasser) zum Durchleiten eines oberirdischen Gewässers durch einen Deich.');
INSERT INTO bauwerksfunktion VALUES (2080, 53009, 'Barrier', 'Sperrwerk' , '''Sperrwerk'' ist ein Bauwerk in einem Tideflussgewässer mit Verschlusseinrichtung zum Absperren bestimmter Tiden, vor allem zum Schutz gegen Sturmfluten auch bei Tidehäfen.');
INSERT INTO bauwerksfunktion VALUES (2085, 53009, 'Sealing structure', 'Verschlussbauwerk' , '''Verschlussbauwerk'' ist ein Bauwerk mit einem Verschlussmechanismus zur Regulierung des Wasserablaufs bzw. zum Schutz vor Hochwasser.');
INSERT INTO bauwerksfunktion VALUES (2090, 53009, 'Pumping station', 'Schöpfwerk' , '''Schöpfwerk'' ist eine Anlage, in der Pumpen Wasser einem höher gelegenen Vorfluter zuführen, u. a. zur künstlichen Entwässerung von landwirtschaftlich genutzten Flächen und im Falle von Polder- und Mündungsschöpfwerken auch zur Sicherstellung des Hochwasser- oder Überschwemmungsschutzes.');
INSERT INTO bauwerksfunktion VALUES (2110, 53009, 'Fish ladder', 'Fischtreppe' , '''Fischtreppe''ist eine Vorrichtung mit Stufen oder Wasserbecken für Fische, um Höhenunterschiede im Gewässer zu überwinden.');
INSERT INTO bauwerksfunktion VALUES (2120, 53009, 'Gauge', 'Pegel' , '''Pegel'' ist eine Messeinrichtung zur Feststellung des Wasserstandes von Gewässern.');
INSERT INTO bauwerksfunktion VALUES (2130, 53009, 'Embankment stabilisation', 'Uferbefestigung' , '''Uferbefestigung'' ist eine Anlage zum Schutze des Ufers.');
INSERT INTO bauwerksfunktion VALUES (2131, 53009, 'Breakwater, groyne', 'Wellenbrecher, Buhne' , '''Wellenbrecher, Buhne'' ist ein ins Meer oder in den Fluss hinein angelegtes Bauwerk zum Uferschutz aus Buschwerk, Holz, Stein, Stahlbeton oder Asphalt.');
INSERT INTO bauwerksfunktion VALUES (2132, 53009, 'Lahnung', 'Lahnung' , '''Lahnung'' ist ein Bauwerk zum Küstenschutz und zur Landgewinnung zumeist im Wattenmeer. Es besteht aus doppelten Holzpflockreihen, mit dazwischen geschnürten Sträuchern, den sog. Faschinen. Bei ablaufendem Wasser sammeln sich hinter der Lahnung Sedimente und Schlick.');
INSERT INTO bauwerksfunktion VALUES (2133, 53009, 'Harbour dam, pier', 'Hafendamm, Mole' , '''Hafendamm, Mole'' ist ein in das Wasser vorgestreckter Steindamm, der eine Hafeneinfahrt begrenzt und das Hafenbecken vor Strömung und Wellenschlag schützt.');
INSERT INTO bauwerksfunktion VALUES (2134, 53009, 'Yard', 'Höft' , '''Höft'' ist eine vorspringende Ecke bei Kaimauern in einem Hafen.');
INSERT INTO bauwerksfunktion VALUES (2135, 53009, 'Revetment', 'Deckwerk' , '''Deckwerk'' ist ein geböschter Uferschutz an Schardeichen (Deiche ohne Vorland).');
INSERT INTO bauwerksfunktion VALUES (2136, 53009, 'Embankment wall, quay wall', 'Ufermauer, Kaimauer' , '''Ufermauer, Kaimauer'' ist eine Mauer entlang der Uferlinie eines Gewässers zum Schutz des Ufers bzw. eine Uferbefestigung im Hafengelände zum Anlegen von Schiffen.');
INSERT INTO bauwerksfunktion VALUES (9999, 53009, 'Other', 'Sonstiges' , '''Sonstiges'' bedeutet, dass die Funktion bekannt, aber nicht in der Attributwertliste aufgeführt ist.');

ALTER TABLE "sie03_f" ADD CONSTRAINT bwf_fk FOREIGN KEY (bwf, objart) REFERENCES bauwerksfunktion(code, objart);
ALTER TABLE "sie03_l" ADD CONSTRAINT bwf_fk FOREIGN KEY (bwf, objart) REFERENCES bauwerksfunktion(code, objart);
--Table "sie03_p" contains identical values for bwf which apply to different classes of objects. Hence a simple FK cannot be added.
--2 out of 5 examples are: 1610 Zoo/Canopy, 1650 Ramp/Staircase
--We add a composite key based on bwf and class identifier i.e. objart.
ALTER TABLE "sie03_p" ADD CONSTRAINT bwf_fk FOREIGN KEY (bwf, objart) REFERENCES bauwerksfunktion(code, objart);
--TODO: Table "sie05_p" contains some invalid values for bwf e.g. 9999#1003, 1008#1003 which need to be cleaned
--ALTER TABLE "sie05_p" ADD CONSTRAINT bwf_fk FOREIGN KEY (bwf) REFERENCES bauwerksfunktion(code);
ALTER TABLE "ver06_f" ADD CONSTRAINT bwf_fk FOREIGN KEY (bwf, objart) REFERENCES bauwerksfunktion(code, objart);
ALTER TABLE "ver06_l" ADD CONSTRAINT bwf_fk FOREIGN KEY (bwf, objart) REFERENCES bauwerksfunktion(code, objart);
ALTER TABLE "ver06_p" ADD CONSTRAINT bwf_fk FOREIGN KEY (bwf, objart) REFERENCES bauwerksfunktion(code, objart);


-- Attribute: sportart
CREATE TABLE sportart (
          code VARCHAR(4) PRIMARY KEY,
          name_en TEXT,
          name_de TEXT,
          definition_de TEXT,
          CONSTRAINT check_column_format CHECK (
              code ~ '^[0-9]{4}$'
              OR LENGTH(code) = 4
)
    );

INSERT INTO sportart VALUES (1010, 'Ball sports', 'Ballsport' , '''Ballsport'' bedeutet, dass ein Spielfeld oder Stadion zur Ausübung des Ballsports genutzt wird.');
INSERT INTO sportart VALUES (1011, 'Football', 'Fußball' , '''Fußball'' bedeutet, dass ein Spielfeld oder Stadion zum Fußball spielen genutzt wird.');
INSERT INTO sportart VALUES (1020, 'Athletics', 'Leichtathletik' , '''Leichtathletik'' bedeutet, dass ein Spielfeld oder Stadion zur Ausübung verschiedener Leichtathletikdisziplinen genutzt wird.');
INSERT INTO sportart VALUES (1030, 'Tennis', 'Tennis' , '''Tennis'' bedeutet, dass ein Spielfeld oder Stadion zum Tennis spielen genutzt wird.');
INSERT INTO sportart VALUES (1040, 'Horse riding', 'Reiten' , '''Reiten'' bedeutet, dass ein Stadion, ein Spielfeld oder eine Rennbahn zur Ausübung des Reitsports genutzt wird.');
INSERT INTO sportart VALUES (1050, 'Swimming', 'Schwimmen' , '''Schwimmen'' bedeutet, dass ein Stadion zum Schwimmen genutzt wird.');
INSERT INTO sportart VALUES (1060, 'Skiing', 'Ski', '''Ski'' bedeutet, dass ein Stadion zur Ausübung des Skisports genutzt wird.');
INSERT INTO sportart VALUES (1070, 'Ice sports, roller skating', 'Eissport, Rollschuhlaufen' , '''Eissport, Rollschuhlaufen'' bedeutet, dass ein Bauwerk oder eine Anlage zur Ausübung des Eis- oder des Rollschuhsports genutzt wird.');
INSERT INTO sportart VALUES (1071, 'Ice skating, ice hockey', 'Eislauf, Eishockey' , '''Eislauf, Eishockey'' bedeutet, dass ein Bauwerk oder eine Anlage zur Ausübung des Eissports genutzt wird.');
INSERT INTO sportart VALUES (1072, 'Rollschuhlaufen', 'Rollschuhlaufen' , '''Rollschuhlaufen'' bedeutet, dass ein Bauwerk oder eine Anlage zur Ausübung des Rollschuhsports genutzt wird.');
INSERT INTO sportart VALUES (1080, 'Skating', 'Skating' , '''Skating'' bedeutet, dass eine Laufbahn zum Skaten genutzt wird.');
INSERT INTO sportart VALUES (1090, 'Motorsports', 'Motorrennsport' , '''Motorrennsport'' bedeutet, dass eine Rennbahn zur Ausübung des Motorrennsports genutzt wird.');
INSERT INTO sportart VALUES (1100, 'Cycling', 'Radsport' , '''Radsport'' bedeutet, dass ein Stadion oder eine Rennbahn zur Ausübung des Radsports genutzt wird.');
INSERT INTO sportart VALUES (1110, 'Horse racing', 'Pferderennsport' , '''Pferderennsport'' bedeutet, dass eine Rennbahn zur Ausübung des Pferderennsports genutzt wird.');
INSERT INTO sportart VALUES (1115, 'Dog racing', 'Hunderennsport' , '''Hunderennsport'' bedeutet, dass eine Rennbahn zur Ausübung des Hunderennsports genutzt wird.');
INSERT INTO sportart VALUES (1120, 'Dog sports', 'Hundesport' , '''Hundesport'' sind Sportanlagen für Hunde, die dem Training, Ausbildung, aber auch dem Wettkampf (keine Hunderennen!) dienen.');


-- Attribute: archaeologischertyp
CREATE TABLE archaeologischertyp (
                          code VARCHAR(4) PRIMARY KEY ,
                          name_en TEXT,
                          name_de TEXT,
                          definition_de TEXT,
                          CONSTRAINT check_column_format CHECK (
                              code ~ '^[0-9]{4}$'
                              OR LENGTH(code) = 4
)
    );

INSERT INTO archaeologischertyp VALUES (1000, 'Grave', 'Grab' , '''Grab'' ist eine künstlich geschaffene Bestattungsstätte unter, auf oder über der Erdoberfläche.');
INSERT INTO archaeologischertyp VALUES (1010, 'Large stone tomb (dolmen, megalithic bed)', 'Großsteingrab (Dolmen, Hünenbett)' , '''Großsteingrab (Dolmen, Hünenbett)'' ist ein Grab mit Steineinbau, d. h. es ist ein aus großen Steinen (z.B. Findlingen) errichteter Grabbau.');
INSERT INTO archaeologischertyp VALUES (1020, 'Burial mound (barrow)', 'Grabhügel (Hügelgrab)' , '''Grabhügel (Hügelgrab)'' ist ein meist runder oder ovaler Hügel, der über einer ur- oder frühgeschichtlichen Bestattung aus Erde aufgeschüttet oder aus Plaggen aufgeschichtet wurde.');
INSERT INTO archaeologischertyp VALUES (1100, 'Historic water pipe', 'Historische Wasserleitung' , '''Historische Wasserleitung'' ist ein meist offenes System von Gräben, Kunstgräben und Kanälen, in dem Wasser transportiert wird.');
INSERT INTO archaeologischertyp VALUES (1110, 'Aqueduct', 'Aquädukt' , '''Aquädukt'' ist ein brückenartiges Steinbauwerk zur Überführung von Freispiegel-Wasserleitungen mit natürlichem Gefälle über Täler oder andere Bodenunebenheiten.');
INSERT INTO archaeologischertyp VALUES (1200, 'Fortification (rampart, ditch)', 'Befestigung (Wall, Graben)' , '''Befestigung (Wall, Graben)'' ist ein aus Erde aufgeschütteter Grenz-, Schutz- oder Stadtwall. Zu der Befestigung (Wall) zählen auch Limes und Landwehr.');
INSERT INTO archaeologischertyp VALUES (1210, 'Watchtower (Roman), control centre', 'Wachturm (römisch), Warte', '''Wachtturm (römisch), Warte'' ist ein allein oder in Verbindung mit einem Befestigungssystem (Limes) stehender Beobachtungsturm.');
INSERT INTO archaeologischertyp VALUES (1300, 'Stone painting', 'Steinmal' , '''Steinmal'' ist eine kultische oder rechtliche Kennzeichnung, bestehend aus einzelnen oder Gruppen von Steinen.');
INSERT INTO archaeologischertyp VALUES (1400, 'Fortification (castle ruins)', 'Befestigung (Burgruine)' , '''Befestigung (Burgruine)'' ist eine künstliche Anlage zur Sicherung von Leben und Gut.');
INSERT INTO archaeologischertyp VALUES (1410, 'Castle (fortress, rampart)', 'Burg (Fliehburg, Ringwall)' , '''Burg (Fliehburg, Ringwall)'' ist eine ur- oder frühgeschichtliche runde, ovale oder an Gegebenheiten des Geländes (Böschungskanten) angepasste Befestigungsanlage, die aus einem Erdwall mit oder ohne Holzeinbauten besteht.');
INSERT INTO archaeologischertyp VALUES (1420, 'Sconce', 'Schanze' , '''Schanze'' ist eine mittelalterliche oder neuzeitliche, in der Regel geschlossene, quadratische, rechteckige oder sternförmige Wallanlage mit Außengraben.');
INSERT INTO archaeologischertyp VALUES (1430, 'Warehouse', 'Lager' , '''Lager'' ist die Bezeichnung für ein befestigtes Truppenlager in der Römer- oder in der Neuzeit (z.B. bei Belagerungen im 30 jährigen Krieg).');
INSERT INTO archaeologischertyp VALUES (1500, 'Historic wall', 'Historische Mauer' , '''Historische Mauer'' ist eine Mauer mit kulturgeschichtlicher Bedeutung.');
INSERT INTO archaeologischertyp VALUES (1510, 'City wall', 'Stadtmauer' , '');
INSERT INTO archaeologischertyp VALUES (1520, 'Other historic wall', 'Sonstige historische Mauer' , '');
INSERT INTO archaeologischertyp VALUES (9999, 'Other', 'Sonstiges' , '''Sonstiges'' bedeutet, dass der archäologische Typ bekannt, aber nicht in der Attributwertliste aufgeführt ist');

-- Attribute: abbaugut
CREATE TABLE abbaugut (
    code VARCHAR(4),
    objart VARCHAR(5).
    name_en TEXT,
    name_de TEXT,
    definition_de TEXT,
    PRIMARY KEY (code, objart),
    CONSTRAINT check_column_format CHECK (
       code ~ '^[0-9]{4}$'
       OR LENGTH(code) = 4
                      )
    );
INSERT INTO abbaugut VALUES (1000, 41004, 'Soil', 'Erden, Lockergestein', '''Erden, Lockergestein'' bedeutet, dass feinkörnige Gesteine abgebaut werden.');
INSERT INTO abbaugut VALUES (1001, 41004, 'Clay', 'Ton', '''Ton'' ist ein Abbaugut, das aus gelblichem bis grauem Lockergestein besteht und durch Verwitterung älterer Gesteine entsteht.');
INSERT INTO abbaugut VALUES (1003, 41004, 'Kaolin', 'Kaolin', '''Kaolin'' ist ein Abbaugut, das aus weißem, erdigem Gestein, fast reinem Aluminiumsilikat (kieselsaure Tonerde) besteht.');
INSERT INTO abbaugut VALUES (1007, 41004, 'Lime, lime tuff, chalk', 'Kalk, Kalktuff, Kreide', '''Kalk, Kalktuff, Kreide'' ist ein Abbaugut, das aus erdigem weißen Kalkstein besteht.');
INSERT INTO abbaugut VALUES (2000, 41004, 'Stones, rock, solid rock', 'Steine, Gestein, Festgestein', '''Steine, Gestein, Festgestein'' bedeutet, dass grobkörnige oder feste Gesteine abgebaut werden.');
INSERT INTO abbaugut VALUES (2002, 41004, 'Slate, roofing slate', 'Schiefer, Dachschiefer', '''Schiefer, Dachschiefer'' ist ein toniges Abbaugut, das in dünne ebene Platten spaltbar ist.');
INSERT INTO abbaugut VALUES (2003, 41004, 'Metamorphic slate', 'Metamorpher Schiefer', '''Metamorpher Schiefer'' ist ein Abbaugut, dessen ursprüngliche Zusammensetzung und Struktur durch Wärme und Druck innerhalb der Erdkruste verändert worden ist.');
INSERT INTO abbaugut VALUES (2005, 41004, 'Limestone', 'Kalkstein', '''Kalkstein'' ist ein Abbaugut, das als weit verbreitetes Sedimentgestein überwiegend aus Calciumcarbonat besteht.');
INSERT INTO abbaugut VALUES (2006, 41004, 'Dolomite stone', 'Dolomitstein', '''Dolomitstein'' ist ein Abbaugut, das überwiegend aus calcium- und magnesiumhaltigen Mineralien besteht.');
INSERT INTO abbaugut VALUES (2013, 41004, 'Basalt, diabase', 'Basalt, Diabas', '''Basalt, Diabas'' ist ein Abbaugut, das aus basischem Ergussgestein besteht.');
INSERT INTO abbaugut VALUES (2021, 41004, 'Talc slate, soapstone', 'Talkschiefer, Speckstein', '''Talkschiefer, Speckstein'' ist ein farbloses bis graugrünes, sich fettig anfühlendes Abbaugut, das aus dem weichen Mineral Talk besteht.');
INSERT INTO abbaugut VALUES (3000, 41004, 'Ores', 'Erze', '''Erze'' bedeutet, dass die in der Natur vorkommenden, metallhaltigen Mineralien und Mineralgemische abgebaut oder gespeichert werden.');
INSERT INTO abbaugut VALUES (3001, 41004, 'Iron', 'Eisen', '''Eisen'' wird als Eisenerz abgebaut und durch Verhüttung gewonnen.');
INSERT INTO abbaugut VALUES (3002, 41004, 'Non-ferrous metal ores', 'Buntmetallerze', 'Buntmetallerze'' ist das Abbaugut, das alle Nichteisenmetallerze als Sammelbegriff umfasst.');
INSERT INTO abbaugut VALUES (3003, 41004, 'Copper', 'Kupfer', '''Kupfer'' wird als Kupfererz abgebaut und durch Verhüttung gewonnen.');
INSERT INTO abbaugut VALUES (3005, 41004, 'Zinc', 'Zink', '''Zink'' wird als Zinkerz abgebaut und durch spezielle Verfahren gewonnen.');
INSERT INTO abbaugut VALUES (3006, 41004, 'Tin', 'Zinn', '''Zinn'' wird als Zinnerz abgebaut und durch spezielle Verfahren gewonnen.');
INSERT INTO abbaugut VALUES (3007, 41004, 'Bismuth, cobalt, nickel', 'Wismut, Kobalt, Nickel', '''Wismut, Kobalt, Nickel'' werden als Erze abgebaut und durch spezielle Verfahren gewonnen.');
INSERT INTO abbaugut VALUES (3008, 41004, 'Uranium', 'Uran', '''Uran'' wird als Uranerz abgebaut und durch spezielle Verfahren gewonnen.');
INSERT INTO abbaugut VALUES (3009, 41004, 'Manganese', 'Mangan', '''Mangan'' wird als Manganerz abgebaut und durch spezielle Verfahren gewonnen.');
INSERT INTO abbaugut VALUES (3011, 41004, 'Precious metal ores', 'Edelmetallerze', '''Edelmetallerze'' ist das Abbaugut, aus dem Edelmetalle (z. B. Gold, Silber) gewonnen werden.');
INSERT INTO abbaugut VALUES (4000, 41004, 'Fuels and combustibles', 'Treib- und Brennstoffe', '''Treib- und Brennstoffe'' bedeutet, dass die in der Natur vorkommenden brennbaren organischen und anorganischen Substanzen abgebaut oder gewonnen werden.');
INSERT INTO abbaugut VALUES (4020, 41004, 'Coal', 'Kohle', '''Kohle'' ist ein Abbaugut, das durch Inkohlung (Umwandlungsprozess pflanzlicher Substanzen) entstanden ist.');
INSERT INTO abbaugut VALUES (4021, 41004, 'Lignite', 'Braunkohle', '''Braunkohle'' ist ein Abbaugut, das durch einen bestimmten Grad von Inkohlung (Umwandlungsprozess pflanzlicher Substanzen) entstanden ist.');
INSERT INTO abbaugut VALUES (4022, 41004, 'Hard coal', 'Steinkohle', '''Steinkohle'' ist ein Abbaugut, das durch vollständige Inkohlung (Umwandlungsprozess pflanzlicher Substanzen) entstanden ist.');
INSERT INTO abbaugut VALUES (4030, 41004, 'Oil shale', 'Ölschiefer', '''Ölschiefer'' ist ein Abbaugut, das aus dunklem, bitumenhaltigem, tonigem Gestein besteht.');
INSERT INTO abbaugut VALUES (5000, 41004, 'Industrial minerals, salts', 'Industrieminerale, Salze', '''Industrieminerale, Salze'' bedeutet, dass die in der Natur vorkommenden Mineralien abgebaut werden.');
INSERT INTO abbaugut VALUES (5001, 41004, 'Gypsum stone', 'Gipsstein', '''Gipsstein'' ist ein natürliches Abbaugut.');
INSERT INTO abbaugut VALUES (5002, 41004, 'Anhydrite stone', 'Anhydritstein', '''Anhydritstein'' ist ein Abbaugut, das aus wasserfreiem Gips besteht.');
INSERT INTO abbaugut VALUES (5003, 41004, 'Rock salt', 'Steinsalz', '''Steinsalz'' ist ein Abbaugut, das aus Salzstöcken gewonnen wird und aus Natriumchlorid besteht.');
INSERT INTO abbaugut VALUES (5004, 41004, 'Potassium salt', 'Kalisalz', '''Kalisalz'' ist ein Abbaugut, das aus Salzstöcken gewonnen wird und aus Chloriden und Sulfaten besteht.');
INSERT INTO abbaugut VALUES (5005, 41004, 'Calcite', 'Kalkspat', '''Kalkspat'' ist ein weißes oder hell gefärbtes Abbaugut (Calciumcarbonat).');
INSERT INTO abbaugut VALUES (5006, 41004, 'Fluorspar', 'Flussspat', '''Flussspat'' ist ein Abbaugut, das aus Calciumfluorid besteht.');
INSERT INTO abbaugut VALUES (5007, 41004, 'Barite', 'Schwerspat', '''Schwerspat'' ist ein formenreiches, rhombisches weißes bis farbiges Abbaugut.');
INSERT INTO abbaugut VALUES (5011, 41004, 'Graphite', 'Graphit', '''Graphit'' ist ein bleigraues, weiches, metallglänzendes Abbaugut, das aus fast reinem Kohlenstoff besteht.');
INSERT INTO abbaugut VALUES (1000, 41005, 'Soil', 'Erden', '''Erden, Lockergestein'' bedeutet, dass feinkörnige Gesteine abgebaut werden.');
INSERT INTO abbaugut VALUES (1001, 41005, 'Clay', 'Ton', '''Ton'' ist ein Abbaugut, das aus gelblichem bis grauem Lockergestein besteht und durch Verwitterung älterer Gesteine entsteht.');
INSERT INTO abbaugut VALUES (1002, 41005, 'Bentonite', 'Bentonit', '''Bentonit'' ist ein tonartiges Abbaugut, das durch Verwitterung vulkanischer Asche (Tuffe) entstanden ist.');
INSERT INTO abbaugut VALUES (1003, 41005, 'Kaolin', 'Kaolin', '''Kaolin'' ist ein Abbaugut, das aus weißem, erdigem Gestein, fast reinem Aluminiumsilikat (kieselsaure Tonerde) besteht.');
INSERT INTO abbaugut VALUES (1004, 41005, 'Loam', 'Lehm', '''Lehm'' ist ein Abbaugut, das durch Verwitterung entstanden ist und aus gelb bis braun gefärbtem sandhaltigem Ton besteht.');
INSERT INTO abbaugut VALUES (1005, 41005, 'Loess, loess loam', 'Löß, Lößlehm', '''Löß, Lößlehm'' ist ein Abbaugut das aus feinsten gelblichen Sedimenten besteht und eine hohe Wasserspeicherfähigkeit aufweist.');
INSERT INTO abbaugut VALUES (1007, 41005, 'Lime, lime tuff, chalk', 'Kalk, Kalktuff, Kreide', '''Kalk, Kalktuff, Kreide'' ist ein Abbaugut, das aus erdigem weißen Kalkstein besteht.');
INSERT INTO abbaugut VALUES (1008, 41005, 'Sand', 'Sand', '''Sand'' ist ein Abbaugut, das aus kleinen, losen Mineralkörnern (häufig Quarz) besteht.');
INSERT INTO abbaugut VALUES (1009, 41005, 'Gravel, gravel sand', 'Kies, Kiessand', '''Kies, Kiessand'' ist ein Abbaugut, das aus vom Wasser rund geschliffenen Gesteinsbrocken besteht.');
INSERT INTO abbaugut VALUES (1011, 41005, 'Farberden', 'Farberden', '''Farberden'' ist ein Abbaugut, das durch Verwitterung entstanden ist und vorrangig aus eisenhaltigem Gestein besteht.');
INSERT INTO abbaugut VALUES (1012, 41005, 'Quartz sand', 'Quarzsand', '''Quarzsand'' ist ein Abbaugut, das vorwiegend aus kleinen, losen Quarzkörnern besteht.');
INSERT INTO abbaugut VALUES (2000, 41005, 'Stones, rock, solid rock', 'Steine, Gestein, Festgestein', '''Steine, Gestein, Festgestein'' bedeutet, dass grobkörnige oder feste Gesteine abgebaut werden.');
INSERT INTO abbaugut VALUES (2001, 41005, 'Claystone', 'Tonstein', '''Tonstein'' ist ein gelblich bis graues Abbaugut, das überwiegend aus Tonmineralien besteht.');
INSERT INTO abbaugut VALUES (2002, 41005, 'Slate, roofing slate', 'Schiefer, Dachschiefer', '''Schiefer, Dachschiefer'' ist ein toniges Abbaugut, das in dünne ebene Platten spaltbar ist.');
INSERT INTO abbaugut VALUES (2003, 41005, 'Metamorphic slate', 'Metamorpher Schiefer', '''Metamorpher Schiefer'' ist ein Abbaugut, dessen ursprüngliche Zusammensetzung und Struktur durch Wärme und Druck innerhalb der Erdkruste verändert worden ist.');
INSERT INTO abbaugut VALUES (2004, 41005, 'Marlstone', 'Mergelstein', '''Mergelstein'' ist ein Abbaugut, das sich größtenteils aus Ton und Kalk zusammensetzt.');
INSERT INTO abbaugut VALUES (2005, 41005, 'Limestone', 'Kalkstein', '''Kalkstein'' ist ein Abbaugut, das als weit verbreitetes Sedimentgestein überwiegend aus Calciumcarbonat besteht.');
INSERT INTO abbaugut VALUES (2006, 41005, 'Dolomite stone', 'Dolomitstein', '''Dolomitstein'' ist ein Abbaugut, das überwiegend aus calcium- und magnesiumhaltigen Mineralien besteht.');
INSERT INTO abbaugut VALUES (2007, 41005, 'Travertine', 'Travertin', '''Travertin'' ist ein Abbaugut, das aus gelblichen Kiesel- oder Kalktuffen besteht.');
INSERT INTO abbaugut VALUES (2008, 41005, 'Marble', 'Marmor', '''Marmor'' ist ein Abbaugut, das als rein weißer kristalliner, körniger Kalkstein (Calciumcarbonat) vorkommt.');
INSERT INTO abbaugut VALUES (2009, 41005, 'Sandstone', 'Sandstein', '''Sandstein'' ist ein Abbaugut, das aus verfestigtem Sedimentgestein besteht.');
INSERT INTO abbaugut VALUES (2010, 41005, 'Greywacke', 'Grauwacke', '''Grauwacke'' ist ein Abbaugut, das aus tonhaltigem Sandstein besteht und mit Gesteinsbruchstücken angereichert sein kann.');
INSERT INTO abbaugut VALUES (2012, 41005, 'Gneiss', 'Gneis', '''Gneis'' ist ein metamorphes Abbaugut mit Schieferung, das aus Feldspat, Quarz und Glimmer besteht.');
INSERT INTO abbaugut VALUES (2013, 41005, 'Basalt, diabase', 'Basalt, Diabas', '''Basalt, Diabas'' ist ein Abbaugut, das aus basischem Ergussgestein besteht.');
INSERT INTO abbaugut VALUES (2015, 41005, 'Porphyry, quartz porphyry', 'Porphyr, Quarzporphyr', '''Porphyr, Quarzporphyr'' ist ein eruptiv entstandenes Abbaugut, das aus einer dichten Grundmasse und groben Einsprenglingen besteht.');
INSERT INTO abbaugut VALUES (2016, 41005, 'Granite', 'Granit', '''Granit'' ist ein eruptiv entstandenes Abbaugut, das aus körnigem Feldspat, Quarz, Glimmer besteht.');
INSERT INTO abbaugut VALUES (2017, 41005, 'Granodiorite', 'Granodiorit', 'Granodiorit'' ist ein hell- bis dunkelgraues Abbaugut. Es ist ein mittelkörniges Tiefengestein mit den Hauptbestandteilen Feldspat, Quarz, Hornblende und Biotit.');
INSERT INTO abbaugut VALUES (2018, 41005, 'Tuff, pumice stone', 'Tuff-, Bimsstein', '''Tuff-, Bimsstein'' ist ein helles, sehr poröses Abbaugut, das durch rasches Erstarren der Lava entstanden ist.');
INSERT INTO abbaugut VALUES (2019, 41005, 'Trass', 'Trass', '''Trass'' ist ein Abbaugut, das aus vulkanischem Aschentuff (Bimsstein) besteht.');
INSERT INTO abbaugut VALUES (2020, 41005, 'Lava slag', 'Lavaschlacke', '''Lavaschlacke'' ist ein Abbaugut, das aus ausgestoßenem, geschmolzenen Vulkangestein besteht.');
INSERT INTO abbaugut VALUES (2021, 41005, 'Talc slate, soapstone', 'Talkschiefer, Speckstein', '''Talkschiefer, Speckstein'' ist ein farbloses bis graugrünes, sich fettig anfühlendes Abbaugut, das aus dem weichen Mineral Talk besteht.');
INSERT INTO abbaugut VALUES (4000, 41005, 'Fuels and combustibles', 'Treib- und Brennstoffe', '''Treib- und Brennstoffe'' bedeutet, dass die in der Natur vorkommenden brennbaren organischen und anorganischen Substanzen abgebaut oder gewonnen werden.');
INSERT INTO abbaugut VALUES (4010, 41005, 'Peat', 'Torf', '''Torf'' ist ein Abbaugut, das aus der unvollkommenen Zersetzung abgestorbener pflanzlicher Substanz unter Luftabschluss in Mooren entstanden ist.');
INSERT INTO abbaugut VALUES (4020, 41005, 'Coal', 'Kohle', '''Kohle'' ist ein Abbaugut, das durch Inkohlung (Umwandlungsprozess pflanzlicher Substanzen) entstanden ist.');
INSERT INTO abbaugut VALUES (4021, 41005, 'Lignite', 'Braunkohle', '''Braunkohle'' ist ein Abbaugut, das durch einen bestimmten Grad von Inkohlung (Umwandlungsprozess pflanzlicher Substanzen) entstanden ist.');
INSERT INTO abbaugut VALUES (4022, 41005, 'Hard coal', 'Steinkohle', '''Steinkohle'' ist ein Abbaugut, das durch vollständige Inkohlung (Umwandlungsprozess pflanzlicher Substanzen) entstanden ist.');
INSERT INTO abbaugut VALUES (4030, 41005, 'Oil shale', 'Ölschiefer', '''Ölschiefer'' ist ein Abbaugut, das aus dunklem, bitumenhaltigen, tonigen Gestein besteht.');
INSERT INTO abbaugut VALUES (5000, 41005, 'Industrial minerals, salts', 'Industrieminerale, Salze', '''Industrieminerale, Salze'' bedeutet, dass die in der Natur vorkommenden Mineralien abgebaut werden.');
INSERT INTO abbaugut VALUES (5001, 41005, 'Gypsum stone', 'Gipsstein', '''Gipsstein'' ist ein natürliches Abbaugut.');
INSERT INTO abbaugut VALUES (5002, 41005, 'Anhydrite stone', 'Anhydritstein', '''Anhydritstein'' ist ein Abbaugut, das aus wasserfreiem Gips besteht.');
INSERT INTO abbaugut VALUES (5005, 41005, 'Calcite', 'Kalkspat', '''Kalkspat'' ist ein weißes oder hell gefärbtes Abbaugut (Calciumcarbonat).');
INSERT INTO abbaugut VALUES (5008, 41005, 'Quartz', 'Quarz', '''Quarz'' ist ein Abbaugut, das aus verschiedenen Gesteinsarten (Granit, Gneis, Sandstein) gewonnen wird.');
INSERT INTO abbaugut VALUES (5009, 41005, 'Feldspar', 'Feldspat', '''Feldspat'' ist ein weiß bis grauweißes gesteinsbildendes Mineral von blättrigem Bruch, das abgebaut wird.');
INSERT INTO abbaugut VALUES (5010, 41005, 'Pegmatite sand', 'Pegmatitsand', '''Pegmatitsand'' ist ein Abbaugut, das durch Verwitterung von Granit und Gneis entstanden ist.');
INSERT INTO abbaugut VALUES (9999, 41005, 'Other', 'Sonstiges', '''Sonstiges'' bedeutet, dass das Abbaugut bekannt, aber nicht in der Attributwertliste aufgeführt ist.');

ALTER TABLE "sie02_f" ADD CONSTRAINT agt_fk FOREIGN KEY (agt, objart) REFERENCES konstruktionsmerkmalbauart(code, objart);

-- Attribute: konstruktionsmerkmalbauart
CREATE TABLE konstruktionsmerkmalbauart (
                          code VARCHAR(4),
                          name_en TEXT,
                          name_de TEXT,
                          definition_de TEXT,
                          PRIMARY KEY (code, objart),
                          CONSTRAINT check_column_format CHECK (
                              code ~ '^[0-9]{4}$'
                              OR LENGTH(code) = 4
)
    );

INSERT INTO konstruktionsmerkmalbauart VALUES (1010, 'Boat lift', 'Schiffshebewerk', '''Schiffshebewerk'' ist ein Bauwerk zum Überwinden einer Fallstufe (in Binnenwasserstraßen und Kanälen) mit Förderung der Schiffe in einem Trog.');
INSERT INTO konstruktionsmerkmalbauart VALUES (1020, 'Pund lock', 'Kammerschleuse', '''Kammerschleuse'' ist ein Bauwerk zum Überwinden einer Fallstufe, in dem durch Füllen oder Leeren der Schleusenkammer Schiffe gehoben oder gesenkt werden.');

ALTER TABLE "sie04_l" ADD CONSTRAINT kon_fk FOREIGN KEY (kon) REFERENCES konstruktionsmerkmalbauart(code);
ALTER TABLE "sie04_p" ADD CONSTRAINT kon_fk FOREIGN KEY (kon) REFERENCES konstruktionsmerkmalbauart(code);

-- Attribute: anzahlderstreckengleise
CREATE TABLE anzahlderstreckengleise (
            code VARCHAR(4) PRIMARY KEY,
            name_en TEXT,
            name_de TEXT,
            definition_de TEXT,
            CONSTRAINT check_column_format CHECK (
                code ~ '^[0-9]{4}$'
                OR LENGTH(code) = 4
)
    );

INSERT INTO anzahlderstreckengleise VALUES (1000, 'Single track', 'Eingleisig', '''Eingleisig'' bedeutet, dass für ''Bahnstrecke'' nur ein Gleis für beide Fahrtrichtungen zur Verfügung steht.');
INSERT INTO anzahlderstreckengleise VALUES (2000, 'Double track', 'Zweigleisig', '''Zweigleisig'' bedeutet, dass für ''Bahnstrecke'' je ein Gleis für eine Fahrtrichtung zur Verfügung steht.');

ALTER TABLE "ver03_l" ADD CONSTRAINT gls_fk FOREIGN KEY (gls) REFERENCES anzahlderstreckengleise(code);


-- Attribute: spurweite
CREATE TABLE spurweite (
             code VARCHAR(4) PRIMARY KEY ,
             name_en TEXT,
             name_de TEXT,
             definition_de TEXT,
             PRIMARY KEY (code, objart),
             CONSTRAINT check_column_format CHECK (
                 code ~ '^[0-9]{4}$'
                 OR LENGTH(code) = 4
)
    );

INSERT INTO spurweite VALUES (1000, 'Standard gauge', 'Normalspur (Regelspur, Vollspur)', '''Normalspur (Regelspur, Vollspur)'' hat eine Spurweite von 1435 mm. Das ist das Innenmaß zwischen den Innenkanten der Schienenköpfe eines Gleises.');
INSERT INTO spurweite VALUES (2000, 'Narrow gauge', 'Schmalspur', '''Schmalspur'' ist eine Spurweite, die kleiner ist als 1435 mm.');
INSERT INTO spurweite VALUES (3000, 'Broad gauge', 'Breitspur', '''Breitspur'' ist eine Spurweite, die größer ist als 1435 mm.');
INSERT INTO spurweite VALUES (9997, 'Attribute not applicable', 'Attribut trifft nicht zu', '''Attribut trifft nicht zu'' bedeutet, dass keiner der in der Werteliste aufgeführten Attributwerte dem vorliegenden Sachverhalt entspricht.');

ALTER TABLE "ver03_l" ADD CONSTRAINT gls_fk FOREIGN KEY (spw) REFERENCES spurweite(code);

-- Attribute: spurweite
CREATE TABLE verkehrsdienst (
           code VARCHAR(4) PRIMARY KEY,
           name_en TEXT,
           name_de TEXT,
           definition_de TEXT,
           CONSTRAINT check_column_format CHECK (
               code ~ '^[0-9]{4}$'
               OR LENGTH(code) = 4
)
    );

INSERT INTO verkehrsdienst VALUES (1000, 'Long distance stop', 'Fernverkehrshalt', '''Fernverkehrshalt'' bedeutet, dass an der Bahnverkehrsanlage von einem Eisenbahnverkehrsunternehmen ein planmäßiger Halt im nationalen oder internationalen Schienenpersonenfernverkehrsdienst erbracht wird.');

ALTER TABLE "ver03_l" ADD CONSTRAINT vkd_fk FOREIGN KEY (vkd) REFERENCES verkehrsdienst(code);

-- Attribute: nutzung
CREATE TABLE nutzung (
        code VARCHAR(4),
        objart VARCHAR(5),
        name_en TEXT,
        name_de TEXT,
        definition_de TEXT,
        PRIMARY KEY (code, objart),
        CONSTRAINT check_column_format CHECK (
            code ~ '^[0-9]{4}$'
            OR LENGTH(code) = 4
)
    );

INSERT INTO nutzung VALUES (1000, 31001, 'Civilian', 'Zivil', '''Zivil'' wird für ein Gebäude verwendet, das privaten, öffentlichen oder religiösen Zwecken dient und nicht militärisch genutzt wird.');
INSERT INTO nutzung VALUES (1100, 31001, 'Private', 'Privat', '''Privat'' bezeichnet ein Gebäude, das wohn- oder privatwirtschaftlichen Zwecken dient.');
INSERT INTO nutzung VALUES (1200, 31001, 'Public', 'Öffentlich', '''Öffentlich'' bedeutet, dass in einem Gebäude Aufgaben der öffentlichen Hand wahrgenommen werden oder dass das ''Gebäude'' für die Nutzung durch die Allgemeinheit vorgesehen ist.');
INSERT INTO nutzung VALUES (1300, 31001, 'Religious', 'Religiös', '''Religiös'' bezeichnet ein Gebäude, das religiösen Zwecken dient.');
INSERT INTO nutzung VALUES (2000, 31001, 'Military', 'Militärisch', '''Militärisch'' bedeutet, dass das ''Gebäude'' von Streitkräften genutzt wird.');
INSERT INTO nutzung VALUES (1000, 42015, 'Civilian', 'Zivil', '''Zivil'' bedeutet, dass ''Flugverkehr'' privaten oder öffentlichen Zwecken dient und nicht militärisch genutzt wird.');
INSERT INTO nutzung VALUES (2000, 42015, 'Military', 'Militärisch', '''Militärisch'' bedeutet, dass ''Flugverkehr'' nur von Streitkräften genutzt wird.');
INSERT INTO nutzung VALUES (3000, 42015, 'Partly civilian, partly military', 'Teils zivil, teils militärisch', '''Teils zivil, teils militärisch'' bedeutet dass ''''Flugverkehr'' sowohl zivil als auch militärisch genutzt wird.');
INSERT INTO nutzung VALUES (1000, 43002, 'Forestry area', 'Forstwirtschaftsfläche', '''Forstwirtschaftsfläche'' bezeichnet eine Waldfläche, mit oder ohne Bäume, welche forstwirtschaftlich genutzt wird. Hierzu zählen keine Kurzumtriebsplantagen.');
INSERT INTO nutzung VALUES (2000, 43002, 'Not managed', 'Unbewirtschaftet', '''Unbewirtschaftet'' bezeichnet eine Waldfläche, mit oder ohne Bäume, welche nicht bewirtschaftet bzw. nicht wirtschaftlich genutzt wird. Hierzu können auch Waldflächen unter Freileitungen zählen.');
INSERT INTO nutzung VALUES (3000, 43002, 'Forest burial area', 'Waldbestattungsfläche', '''Waldbestattungsfläche'' ist eine Fläche im Wald, die zur Bestattung dient oder gedient hat.');
INSERT INTO nutzung VALUES (1000, 44005, 'Civilian', 'Zivil', '''Zivil'' bedeutet, dass ''Hafenbecken'' privaten oder öffentlichen Zwecken dient und nicht militärisch genutzt wird.');
INSERT INTO nutzung VALUES (2000, 44005, 'Military', 'Militärisch', '''Militärisch'' bedeutet, dass ''Hafenbecken'' nur von Streitkräften genutzt wird.');
INSERT INTO nutzung VALUES (3000, 44005, 'Partly civilian, partly military', 'Teils zivil, teils militärisch', '''Teils zivil, teils militärisch'' bedeutet, dass ''Hafenbecken'' sowohl zivil als auch militärisch genutzt wird.');
INSERT INTO nutzung VALUES (1000, 44006, 'Drinking water', 'Trinkwasser', '''Trinkwasser'' im vorliegenden Sinne bezeichnet Wasser, das für den menschlichen Genuss geeignet ist.');
INSERT INTO nutzung VALUES (2000, 44006, 'Energy', 'Energie', '''Energie'' weist die Nutzung eines Stehenden Gewässers zur Energiegewinnung aus.');
INSERT INTO nutzung VALUES (3000, 44006, 'Industrial water', 'Brauchwasser', '''Brauchwasser'' dient spezifischen technischen, gewerblichen, industriellen, landwirtschaftlichen, hauswirtschaftlichen oder ähnlichen Zwecken, ohne dass hierfür Trinkwasserqualität verlangt wird. Hierzu zählen z B. Kesselspeisewasser, Kühlwasser, unterschiedlich aufbereitetes Rohwasser.');
INSERT INTO nutzung VALUES (1000, 52002, 'Civilian', 'Zivil', '''Zivil'' bedeutet, dass ''Hafen'' privaten oder öffentlichen Zwecken dient und nicht militärisch genutzt wird.');
INSERT INTO nutzung VALUES (2000, 52002, 'Military', 'Militärisch', '''Militärisch'' bedeutet, dass ''Hafen'' nur von Streitkräften genutzt wird.');
INSERT INTO nutzung VALUES (3000, 52002, 'Partly civilian, partly military', 'Teils zivil, teils militärisch', '''Teils zivil, teils militärisch'' bedeutet, dass ''Hafen'' sowohl zivil als auch militärisch genutzt wird.');

ALTER TABLE "ver04_f" ADD CONSTRAINT ntz_fk FOREIGN KEY (ntz, objart) REFERENCES verkehrsdienst(code, objart);
ALTER TABLE "veg02_g" ADD CONSTRAINT ntz_fk FOREIGN KEY (ntz, objart) REFERENCES verkehrsdienst(code, objart);

-- Attribute: oberflaechenmaterial
CREATE TABLE oberflaechenmaterial (
                         code VARCHAR(4),
                         objart VARCHAR(5),
                         name_en TEXT,
                         name_de TEXT,
                         definition_de TEXT,
                         PRIMARY KEY (code, objart),
                         CONSTRAINT check_column_format CHECK (
                             code ~ '^[0-9]{4}$'
                             OR LENGTH(code) = 4
)
    );

INSERT INTO oberflaechenmaterial VALUES (1210, 53007, 'Grass, lawn', 'Gras, Rasen', '''Gras, Rasen'' bedeutet, dass die Oberfläche von ''Flugverkehrsanlage'' mit Gras bewachsen ist.');
INSERT INTO oberflaechenmaterial VALUES (1220, 53007, 'Concrete', 'Beton', '''Beton'' bedeutet, dass die Oberfläche von der ''Objektart'' aus Beton besteht.');
INSERT INTO oberflaechenmaterial VALUES (1230, 53007, 'Bitumen, Asphalt', 'Bitumen, Asphalt', '''Bitumen, Asphalt'' bedeutet, dass die Oberfläche von der ''Objektart'' aus Bitumen bzw. Asphalt besteht.');
INSERT INTO oberflaechenmaterial VALUES (1220, 42003, 'Concrete', 'Beton', '''Beton'' bedeutet, dass die Oberfläche von der ''Objektart'' aus Beton besteht.');
INSERT INTO oberflaechenmaterial VALUES (1230, 42003, 'Bitumen, Asphalt', 'Bitumen, Asphalt', '''Bitumen, Asphalt'' bedeutet, dass die Oberfläche von der ''Objektart'' aus Bitumen bzw. Asphalt besteht.');
INSERT INTO oberflaechenmaterial VALUES (1240, 42003, 'Plaster', 'Pflaster', '''Pflaster'' bedeutet, dass die Oberfläche von der ''Objektart'' gepflastert ist.');
INSERT INTO oberflaechenmaterial VALUES (1250, 42003, 'Crushed rock', 'Gestein, zerkleinert', '''Gestein, zerkleinert'' bedeutet, dass die Oberfläche von der ''Objektart'' aus Schotter, Splitt, Sand oder aus einem Gemisch dieser Materialen besteht.');
INSERT INTO oberflaechenmaterial VALUES (1220, 42005, 'Concrete', 'Beton', '''Beton'' bedeutet, dass die Oberfläche von der ''Objektart'' aus Beton besteht.');
INSERT INTO oberflaechenmaterial VALUES (1230, 42005, 'Bitumen, Asphalt', 'Bitumen, Asphalt', '''Bitumen, Asphalt'' bedeutet, dass die Oberfläche von der ''Objektart'' aus Bitumen bzw. Asphalt besteht.');
INSERT INTO oberflaechenmaterial VALUES (1240, 42005, 'Plaster', 'Pflaster', '''Pflaster'' bedeutet, dass die Oberfläche von der ''Objektart'' gepflastert ist.');
INSERT INTO oberflaechenmaterial VALUES (1250, 42005, 'Crushed rock', 'Gestein, zerkleinert', '''Gestein, zerkleinert'' bedeutet, dass die Oberfläche von der ''Objektart'' aus Schotter, Splitt, Sand oder aus einem Gemisch dieser Materialen besteht.');
INSERT INTO oberflaechenmaterial VALUES (1010, 43007, 'Rock', 'Fels', '''Fels'' bedeutet, dass die Erdoberfläche aus einer festen Gesteinsmasse besteht.');
INSERT INTO oberflaechenmaterial VALUES (1020, 43007, 'Stones, gravel', 'Steine, Schotter', '''Steine, Schotter'' bedeutet, dass die Erdoberfläche mit zerkleinertem Gestein unterschiedlicher Größe bedeckt ist.');
INSERT INTO oberflaechenmaterial VALUES (1030, 43007, 'Scree', 'Geröll', '''Geröll'' bedeutet, dass die Erdoberfläche mit durch fließendes Wasser abgerundeten Gesteinen bedeckt ist.');
INSERT INTO oberflaechenmaterial VALUES (1040, 43007, 'Sand', 'Sand', '''Sand'' bedeutet, dass die Erdoberfläche mit kleinen, losen Gesteinskörnern bedeckt ist.');
INSERT INTO oberflaechenmaterial VALUES (1110, 43007, 'Snow', 'Schnee', '''Schnee'' bedeutet, dass die Erdoberfläche für die größte Zeit des Jahres mit Schnee bedeckt ist.');
INSERT INTO oberflaechenmaterial VALUES (1120, 43007, 'Ice, firn', 'Eis, Firn', '''Eis, Firn'' bedeutet, dass die Erdoberfläche mit altem, grobkörnigem, mehrjährigem Schnee im Hochgebirge bedeckt ist, der unter zunehmendem Druck zu Gletschereis wird.');

ALTER TABLE "ver06_l" ADD CONSTRAINT ofm_fk FOREIGN KEY (ofm, objart) REFERENCES oberflaechenmaterial(code, objart);
ALTER TABLE "ver06_p" ADD CONSTRAINT ofm_fk FOREIGN KEY (ofm, objart) REFERENCES oberflaechenmaterial(code, objart);
ALTER TABLE "veg03_f" ADD CONSTRAINT ofm_fk FOREIGN KEY (ofm, objart) REFERENCES oberflaechenmaterial(code, objart);

-- Attribute: art
CREATE TABLE art (
    code VARCHAR(4),
    objart VARCHAR(5),
    name_en TEXT,
    name_de TEXT,
    definition_de TEXT,
    PRIMARY KEY (code, objart),
    CONSTRAINT check_column_format CHECK (
        code ~ '^[0-9]{4}$'
        OR LENGTH(code) = 4
                 )
    );

INSERT INTO art VALUES (1000, 14007, 'Sand', 'Geländereduktion', 'Teil der topografischen Reduktion, der die Abweichung der Erdoberfläche von einer horizontalen Platte oder sphärischen Figur berücksichtigt.');
INSERT INTO art VALUES (2000, 14007, 'Sand', 'Freiluftanomalie', 'Differenz zwischen dem mittels Freiluftreduktion auf das Geoid reduzierten Schwerewert und dem entsprechenden Wert der Normalschwere auf dem Niveauellipsoid.');
INSERT INTO art VALUES (3000, 14007, 'Sand', 'Faye-Anomalie', 'Freiluftanomalie mit zusätzlich angebrachter Geländereduktion');
INSERT INTO art VALUES (3100, 14007, 'Sand', 'Schwereanomalie nach Molodenski', 'Schwere im Oberflächenpunkt minus Normalschwere im zugeordneten Telluroidpunkt');
INSERT INTO art VALUES (4000, 14007, 'Sand', 'Verfeinerte Bougueranomalie', 'Topografische Reduktion erfolgt als Plattenreduktion und Geländereduktion');
INSERT INTO art VALUES (5000, 14007, 'Sand', 'Einfache Bougueranomalie', 'Topografische Reduktion erfolgt nur als Plattenreduktion');
INSERT INTO art VALUES (6000, 14007, 'Sand', 'Bougueranomalie im DHSN96 mit Freiluft- und Plattenreduktion', 'Normalschwere im GRS80');
INSERT INTO art VALUES (9998, 14007, 'Sand', 'Unbekannt', '');
INSERT INTO art VALUES (1000, 15005, 'Sand', 'Privat', '');
INSERT INTO art VALUES (2000, 15005, 'Sand', 'Notar', '');
INSERT INTO art VALUES (3000, 15005, 'Sand', 'Grundbuchamt', '');
INSERT INTO art VALUES (4000, 15005, 'Sand', 'Finanzamt', '');
INSERT INTO art VALUES (5000, 15005, 'Sand', 'Bauaufsichtsbehörde', '');
INSERT INTO art VALUES (6000, 15005, 'Sand', 'Weitere Beteiligte', '');
INSERT INTO art VALUES (1000, 16001, 'Sand', 'Punktkennung', '');
INSERT INTO art VALUES (1300, 16001, 'Sand', 'Punktkennung - Grenzpunkt', '');
INSERT INTO art VALUES (1400, 16001, 'Sand', 'Punktkennung - Besonderer Gebäudepunkt', '');
INSERT INTO art VALUES (1500, 16001, 'Sand', 'Punktkennung - Besonderer topographischer Punkt', '');
INSERT INTO art VALUES (1600, 16001, 'Sand', 'Punktkennung - Besonderer Bauwerkspunkt', '');
INSERT INTO art VALUES (1700, 16001, 'Sand', 'Punktkennung - Aufnahmepunkt', '');
INSERT INTO art VALUES (1800, 16001, 'Sand', 'Punktkennung - Sicherungspunkt', '');
INSERT INTO art VALUES (1900, 16001, 'Sand', 'Punktkennung - Sonstiger Vermessungspunkt', '');
INSERT INTO art VALUES (2000, 16001, 'Sand', 'Punktkennung - Lagefestpunkt', '');
INSERT INTO art VALUES (2100, 16001, 'Sand', 'Punktkennung - Höhenfestpunkt', '');
INSERT INTO art VALUES (2200, 16001, 'Sand', 'Punktkennung - Schwerefestpunkt', '');
INSERT INTO art VALUES (2300, 16001, 'Sand', 'Punktkennung - Referenzstationspunkt', '');
INSERT INTO art VALUES (3000, 16001, 'Sand', 'Flurstückskennzeichen', 'Eine Reservierung von Folgenummern zu einer Nummer darf sich nur auf aktuelle Flurstücke 11001 beziehen und nicht auf dauerhaft reservierte ausfallende Nummern, die keine aktuellen Flurstücke haben.');
INSERT INTO art VALUES (4000, 16001, 'Sand', 'FN-Nummer', '');
INSERT INTO art VALUES (5000, 16001, 'Sand', 'Abmarkungsprotokollnummer', '');
INSERT INTO art VALUES (6000, 16001, 'Sand', 'Buchungsblattkennzeichen', '');
INSERT INTO art VALUES (6100, 16001, 'Sand', 'Katasterblatt', '');
INSERT INTO art VALUES (6200, 16001, 'Sand', 'Pseudoblatt', '');
INSERT INTO art VALUES (6300, 16001, 'Sand', 'Erwerberblatt', '');
INSERT INTO art VALUES (6400, 16001, 'Sand', 'Fiktives Blatt', '');
INSERT INTO art VALUES (1000, 16002, 'Sand', 'Punktkennung - allgemein', '');
INSERT INTO art VALUES (1100, 16002, 'Sand', 'Punktkennung - Grenzpunkt', '');
INSERT INTO art VALUES (1200, 16002, 'Sand', 'Punktkennung - Besonderer Gebäudepunkt', '');
INSERT INTO art VALUES (1300, 16002, 'Sand', 'Punktkennung - Besonderer topographischer Punkt', '');
INSERT INTO art VALUES (1400, 16002, 'Sand', 'Punktkennung - Aufnahmepunkt', '');
INSERT INTO art VALUES (1500, 16002, 'Sand', 'Punktkennung - Sicherungspunkt', '');
INSERT INTO art VALUES (1600, 16002, 'Sand', 'Punktkennung - Sonstiger Vermessungspunkt', '');
INSERT INTO art VALUES (1700, 16002, 'Sand', 'Punktkennung - Besonderer Bauwerkspunkt', '');
INSERT INTO art VALUES (1000, 16003, 'Sand', 'Punktkennung - allgemein', '');
INSERT INTO art VALUES (1100, 16003, 'Sand', 'Punktkennung - Grenzpunkt', '');
INSERT INTO art VALUES (1200, 16003, 'Sand', 'Punktkennung - Besonderer Gebäudepunkt', '');
INSERT INTO art VALUES (1300, 16003, 'Sand', 'Punktkennung - Besonderer topographischer Punkt', '');
INSERT INTO art VALUES (1400, 16003, 'Sand', 'Punktkennung - Aufnahmepunkt', '');
INSERT INTO art VALUES (1500, 16003, 'Sand', 'Punktkennung - Sicherungspunkt', '');
INSERT INTO art VALUES (1600, 16003, 'Sand', 'Punktkennung - Sonstiger Vermessungspunkt', '');
INSERT INTO art VALUES (1700, 16003, 'Sand', 'Punktkennung - Besonderer Bauwerkspunkt', '');
INSERT INTO art VALUES (1100, 31005, 'Sand', 'First', '');
INSERT INTO art VALUES (1200, 31005, 'Sand', 'Traufe', '');
INSERT INTO art VALUES (2100, 31005, 'Sand', 'Eingang', '');
INSERT INTO art VALUES (2200, 31005, 'Sand', 'Lichtschacht', '');
INSERT INTO art VALUES (5511, 42015, 'Sand', 'Internationaler Flughafen', '''Internationaler Flughafen'' ist ein Verkehrsflughafen, der im Luftfahrthandbuch als solcher ausgewiesen ist.');
INSERT INTO art VALUES (5512, 42015, 'Sand', 'Regionalflughafen', '''Regionalflughafen'' ist ein Verkehrsflughafen der gemäß Raumordnungsgesetz als Regionalflughafen eingestuft ist, bzw. als Flughafen, Verkehrsflughafen oder Regionalflughafen im Luftfahrthandbuch ausgewiesen ist.');
INSERT INTO art VALUES (5513, 42015, 'Sand', 'Sonderflughafen', '''Sonderflughafen'' ist ein Flughafen, der im Luftfahrthandbuch als solcher ausgewiesen ist.');
INSERT INTO art VALUES (5521, 42015, 'Sand', 'Verkehrslandeplatz', '''Verkehrslandeplatz'' ist ein Flugplatz, der im Luftfahrthandbuch als Flugplatz, Landeplatz oder Verkehrslandeplatz ausgewiesen ist.');
INSERT INTO art VALUES (5522, 42015, 'Sand', 'Sonderlandeplatz', '''Sonderlandeplatz'' ist ein Flugplatz, der im Luftfahrthandbuch oder in den Bescheiden der zuständigen Luftfahrtbehörden als Sonderlandeplatz ausgewiesen ist.');
INSERT INTO art VALUES (5530, 42015, 'Sand', 'Hubschrauberlandeplatz', '''Hubschrauberlandeplatz'' ist ein Flugplatz, der im Luftfahrthandbuch, in der Luftfahrtkarte 1:500000 (ICAO) oder aufgrund von Ländervorschriften als solcher ausgewiesen ist.');
INSERT INTO art VALUES (5550, 42015, 'Sand', 'Segelfluggelände', '''Segelfluggelände'' ist ein Flugplatz, der in der Luftfahrtkarte 1:500000 (ICAO) für den Segelflugsport ausgewiesen ist.');
INSERT INTO art VALUES (4010, 51008, 'Sand', 'Heilquelle', '');
INSERT INTO art VALUES (4020, 51008, 'Sand', 'Gasquelle, Mofette', '');
INSERT INTO art VALUES (1100, 51010, 'Sand', 'Kommunikationseinrichtung', '');
INSERT INTO art VALUES (1110, 51010, 'Sand', 'Fernsprechhäuschen', '');
INSERT INTO art VALUES (1120, 51010, 'Sand', 'Briefkasten', '');
INSERT INTO art VALUES (1130, 51010, 'Sand', 'Notrufeinrichtung', '');
INSERT INTO art VALUES (1140, 51010, 'Sand', 'Feuermelder', '');
INSERT INTO art VALUES (1150, 51010, 'Sand', 'Polizeirufsäule', '');
INSERT INTO art VALUES (1200, 51010, 'Sand', 'Kabelkasten, Schaltkasten', '');
INSERT INTO art VALUES (1300, 51010, 'Sand', 'Verkehrszeichen', '');
INSERT INTO art VALUES (1310, 51010, 'Sand', 'Verkehrsampel', '');
INSERT INTO art VALUES (1320, 51010, 'Sand', 'Freistehende Hinweistafel, -zeichen', '');
INSERT INTO art VALUES (1330, 51010, 'Sand', 'Wegweiser von besonderer Bedeutung', '');
INSERT INTO art VALUES (1340, 51010, 'Sand', 'Freistehende Warntafel', '');
INSERT INTO art VALUES (1350, 51010, 'Sand', 'Bushaltestelle', '');
INSERT INTO art VALUES (1400, 51010, 'Sand', 'Markierungshinweise, -steine', '');
INSERT INTO art VALUES (1410, 51010, 'Sand', 'Kilometerstein, -tafel', '''Kilometerstein, -tafel'' ist ein Punkt mit einem festen Wert im Netz der Autobahnen oder Schienenbahnen der in der Örtlichkeit durch eine Markierung (z. B. Kilometerstein) repräsentiert wird.');
INSERT INTO art VALUES (1420, 51010, 'Sand', 'Ortsdurchfahrtsstein', '');
INSERT INTO art VALUES (1430, 51010, 'Sand', 'Fischereigrenzstein', '');
INSERT INTO art VALUES (1500, 51010, 'Sand', 'Bahnübergang, Schranke', '');
INSERT INTO art VALUES (1510, 51010, 'Sand', 'Tor', '');
INSERT INTO art VALUES (1600, 51010, 'Sand', 'Laterne, Kandelaber', '');
INSERT INTO art VALUES (1610, 51010, 'Sand', 'Gaslaterne', '');
INSERT INTO art VALUES (1620, 51010, 'Sand', 'Laterne, elektrisch', '');
INSERT INTO art VALUES (1630, 51010, 'Sand', 'Gaskandelaber', '');
INSERT INTO art VALUES (1640, 51010, 'Sand', 'Kandelaber, elektrisch', '');
INSERT INTO art VALUES (1650, 51010, 'Sand', 'Hängende Lampe', '');
INSERT INTO art VALUES (1700, 51010, 'Sand', 'Säule, Werbefläche', '');
INSERT INTO art VALUES (1710, 51010, 'Sand', 'Leuchtsäule', '');
INSERT INTO art VALUES (1910, 51010, 'Sand', 'Fahnenmast', '');
INSERT INTO art VALUES (2100, 51010, 'Sand', 'Straßensinkkasten', '');
INSERT INTO art VALUES (2200, 51010, 'Sand', 'Müllbox', '');
INSERT INTO art VALUES (2300, 51010, 'Sand', 'Kehrichtgrube', '');
INSERT INTO art VALUES (2400, 51010, 'Sand', 'Uhr', '');
INSERT INTO art VALUES (2500, 51010, 'Sand', 'Richtscheinwerfer', '');
INSERT INTO art VALUES (2600, 51010, 'Sand', 'Flutlichtmast', '');
INSERT INTO art VALUES (9999, 51010, 'Other', 'Sonstiges', '''Sonstiges'' bedeutet, dass die Art bekannt, aber in der Attributwertliste nicht aufgeführt ist.');
INSERT INTO art VALUES (1100, 51011, 'Sand', 'First', '');
INSERT INTO art VALUES (1200, 51011, 'Sand', 'Traufe', '');
INSERT INTO art VALUES (2100, 51011, 'Sand', 'Eingang', '');
INSERT INTO art VALUES (1000, 53002, 'Sand', 'Fahrbahn', '');
INSERT INTO art VALUES (1010, 53002, 'Sand', 'Fahrbahnbegrenzungslinie', '');
INSERT INTO art VALUES (1011, 53002, 'Sand', 'Fahrbahnbegrenzungslinie, überdeckt', '');
INSERT INTO art VALUES (2000, 53002, 'Sand', 'Furt', '''Furt'' ist eine zum Überqueren geeignete Stelle in einem Gewässer.');
INSERT INTO art VALUES (3000, 53002, 'Sand', 'Autobahnknoten', '''Autobahnknoten'' ist ein höhengleicher oder höhenungleicher Knoten, der sich aus der verkehrlichen Verknüpfung zweier Autobahnen sowie an Anschlussstellen mit dem nachgeordneten Straßennetz ergibt.');
INSERT INTO art VALUES (3001, 53002, 'Sand', 'Kreuz', '''Kreuz'' ist ein vierarmiger Knotenpunkt in mehreren Ebenen in dem sich zwei Autobahnen kreuzen.');
INSERT INTO art VALUES (3002, 53002, 'Sand', 'Dreieck', '''Dreieck'' ist eine Einmündung einer Autobahn in eine durchgehende Autobahn.');
INSERT INTO art VALUES (3003, 53002, 'Sand', 'Anschlussstelle, Anschluss', '''Anschlussstelle, Anschluss'' ist die verkehrliche Verknüpfung der Autobahn mit dem nachgeordneten Straßennetz.');
INSERT INTO art VALUES (4000, 53002, 'Sand', 'Platz', '''Platz'' ist eine ebene, befestigte oder unbefestigte Fläche.');
INSERT INTO art VALUES (5330, 53002, 'Sand', 'Raststätte, Autohof', '''Raststätte, Autohof'' ist eine Anlage an Verkehrsstraßen mit Bauwerken und Einrichtungen zur Versorgung und Erholung von Reisenden. Dazu gehören auch Autohöfe gemäß der Verwaltungsvorschriften zur Straßenverkehrsordnung (VwV-StVO).');
INSERT INTO art VALUES (6000, 53002, 'Sand', 'Busbahnhof', '''Busbahnhof'' ist eine Verkehrsanlage, die als zentraler Verknüpfungspunkt verschiedener Buslinien dient.');
INSERT INTO art VALUES (9999, 53002, 'Sand', 'Sonstiges', '''Sonstiges'' bedeutet, dass die Art bekannt, aber nicht in der Attributwertliste aufgeführt ist.');
INSERT INTO art VALUES (1103, 53003, 'Sand', 'Fußweg', '''Fußweg'' ist ein Weg, der auf Grund seines Ausbauzustandes nur von Fußgängern zu begehen ist.');
INSERT INTO art VALUES (1105, 53003, 'Sand', 'Karren- und Ziehweg', 'Karrenweg ist ein Weg im Gebirge, der meist sehr steil ist und nur mit einem Gespann befahren werden kann. Ziehweg ist ein Weg, der der Holzabfuhr im Gebirge dient.');
INSERT INTO art VALUES (1106, 53003, 'Sand', 'Radweg', '''Radweg'' ist ein Weg, der als besonders gekennzeichneter und abgegrenzter Teil einer Straße oder mit selbständiger Linienführung für den Fahrradverkehr bestimmt ist');
INSERT INTO art VALUES (1107, 53003, 'Sand', 'Reitweg', '''Reitweg'' ist ein besonders ausgebauter Weg, auf dem ausschließlich das Reiten zugelassen ist.');
INSERT INTO art VALUES (1108, 53003, 'Sand', 'Wattenweg', '');
INSERT INTO art VALUES (1109, 53003, 'Sand', '(Kletter-)Steig im Gebirge', '''(Kletter-)Steig im Gebirge'' ist ein stellenweise mit Drahtseilen gesicherter Pfad, der zur Überwindung besonders steiler Stellen mit Leitern versehen sein kann.');
INSERT INTO art VALUES (1110, 53003, 'Sand', 'Rad- und Fußweg', '''Rad- und Fußweg'' ist ein Weg, der als besonders gekennzeichneter und abgegrenzter Teil einer Straße oder mit selbständiger Linienführung ausschließlich für den Fahrrad- und Fußgängerverkehr bestimmt ist.');
INSERT INTO art VALUES (1111, 53003, 'Sand', 'Skaterstrecke', '''Skaterstrecke'' ist ein für Skater besonders ausgebauter asphaltierter Weg.');
INSERT INTO art VALUES (1200, 53006, 'Sand', 'Drehscheibe', '');
INSERT INTO art VALUES (1310, 53007, 'Sand', 'Startbahn, Landebahn', '''Startbahn, Landebahn'' ist eine Fläche, auf der Flugzeuge starten bzw. landen.');
INSERT INTO art VALUES (1320, 53007, 'Sand', 'Zurollbahn, Taxiway', '''Zurollbahn, Taxiway'' ist ein Verbindungsweg zwischen den Terminals bzw. dem Vorfeld und der Start- und/oder Landebahn.');
INSERT INTO art VALUES (1330, 53007, 'Sand', 'Vorfeld', '''Vorfeld'' ist ein Bereich, in dem Flugzeuge abgefertigt und abgestellt werden.');
INSERT INTO art VALUES (5521, 53007, 'Sand', 'Verkehrslandeplatz', '''Verkehrslandeplatz'' ist ein Flugplatz, der im Luftfahrthandbuch als Flugplatz, Landeplatz oder Verkehrslandeplatz ausgewiesen ist.');
INSERT INTO art VALUES (5522, 53007, 'Sand', 'Sonderlandeplatz', '''Sonderlandeplatz'' ist ein Flugplatz, der im Luftfahrthandbuch oder in den Bescheiden der zuständigen Luftfahrtbehörden als Sonderlandeplatz ausgewiesen ist.');
INSERT INTO art VALUES (5530, 53007, 'Sand', 'Hubschrauberlandeplatz', '''Hubschrauberlandeplatz'' ist ein Flugplatz, der im Luftfahrthandbuch, in der Luftfahrtkarte 1:500000 (ICAO) oder aufgrund von Ländervorschriften als solcher ausgewiesen ist.');
INSERT INTO art VALUES (5550, 53007, 'Sand', 'Segelfluggelände', '''Segelfluggelände'' ist ein Flugplatz, der in der Luftfahrtkarte 1:500000 (ICAO) für den Segelflugsport ausgewiesen ist.');
INSERT INTO art VALUES (5560, 53007, 'Sand', 'Wasserlandeplatz', '''Wasserlandeplatz'' ist ein Flugplatz, der im Luftfahrthandbuch als Sonderlandeplatz mit einem Start- und Landebahnoberflächentyp "Wasser" ausgewiesen ist.');
INSERT INTO art VALUES (9998, 53007, 'Sand', 'Nach Quellenlage nicht zu spezifizieren', '''Nach Quellenlage nicht zu spezifizieren'' bedeutet, dass keine Aussage über die Werteart gemacht werden kann.');
INSERT INTO art VALUES (1410, 53008, 'Sand', 'Bake', '''Bake'' ist ein festgegründetes pfahl- oder gittermastartiges Schifffahrtszeichen mit Kennung durch Form oder Form und Farbe.');
INSERT INTO art VALUES (1420, 53008, 'Sand', 'Leuchtfeuer', '''Leuchtfeuer'' sind Anlagen, die ein Feuer tragen, das über den ganzen Horizont oder in festgelegten Sektoren oder Richtungen gezeigt wird und die bei Tage als Körperzeichen dienen.');
INSERT INTO art VALUES (1430, 53008, 'Sand', 'Kilometerstein', '''Kilometerstein'' ist ein Punkt mit einem festen Wert im Netz der Gewässer, der in der Örtlichkeit durch eine Markierung (z.B. Kilometerstein) repräsentiert wird.');
INSERT INTO art VALUES (1440, 53008, 'Sand', 'Tafel an Gewässern', '');
INSERT INTO art VALUES (1450, 53008, 'Sand', 'Pricke', '');
INSERT INTO art VALUES (1460, 53008, 'Sand', 'Anleger', '''Anleger'' ist eine feste oder schwimmende Einrichtung zum Anlegen von Schiffen.');
INSERT INTO art VALUES (1470, 53008, 'Sand', 'Wasserliegeplatz', '''Wasserliegeplatz'' bezeichnet eine wasserseitige Stelle außerhalb von Hafenbecken, an dem Wasserfahrzeuge vorübergehend oder dauerhaft verankert sind, mit dem Zweck des Güterumschlages (keine Boots-, Strand- oder Landliegeplätze).');
INSERT INTO art VALUES (9999, 53008, 'Sand', 'Sonstiges', '''Sonstiges'' bedeutet, dass die Art bekannt, aber nicht in der Attributwertliste aufgeführt ist.');
INSERT INTO art VALUES (1610, 55001, 'Sand', 'Quelle', '''Quelle'' ist eine natürliche, örtlich begrenzte Austrittsstelle von Wasser.');
INSERT INTO art VALUES (1620, 55001, 'Sand', 'Wasserfall', '''Wasserfall'' ist ein senkrechter oder nahezu senkrechter Absturz eines Wasserlaufs, der über eine oder mehrere natürliche Stufen verlaufen kann.');
INSERT INTO art VALUES (1630, 55001, 'Sand', 'Stromschnelle', '''Stromschnelle'' ist eine Flussstrecke mit höherer Strömungsgeschwindigkeit durch ein besonders starkes Gefälle sowie oft auch geringerer Wassertiefe.');
INSERT INTO art VALUES (1640, 55001, 'Sand', 'Sandbank', '''Sandbank'' ist eine vegetationslose Sand- oder Kiesablagerung auf dem Meeresboden oder in Flüssen, die durch Brandung oder Strömung aufgebaut wird.');
INSERT INTO art VALUES (1650, 55001, 'Sand', 'Watt', '''Watt'' ist ein aus Sand oder Schlick bestehender Boden an flachen Gezeitenküsten und Flüssen, der bei Ebbe ganz oder teilweise trocken fällt.');
INSERT INTO art VALUES (1660, 55001, 'Sand', 'Priel', '''Priel'' ist eine natürliche Rinne im Watt, die auch bei Ebbe Wasser führt.');
INSERT INTO art VALUES (1700, 55001, 'Sand', 'Bodden, Haff', '''Bodden, Haff ist ein vom offenen Meer durch Landzungen abgetrenntes Küstengewässer an der Ostsee.');
INSERT INTO art VALUES (9999, 55001, 'Sand', 'Sonstiges', '');
INSERT INTO art VALUES (1710, 57002, 'Sand', 'Autofährverkehr', '''Autofährverkehr'' ist ein in der Regel nach festem Fahrplan über Flüsse, Seen, Kanäle, Meerengen oder Meeresarme stattfindender Schiffsverkehr zwischen zwei Anlegestellen speziell für Fahrzeuge des Straßenverkehrs.');
INSERT INTO art VALUES (1720, 57002, 'Sand', 'Eisenbahnfährverkehr', '''Eisenbahnfährverkehr'' ist ein in der Regel nach festem Fahrplan über Flüsse, Seen, Kanäle, Meerengen oder Meeresarme stattfindender Schiffsverkehr zwischen zwei Anlegestellen speziell für Fahrzeuge des Schienenverkehrs.');
INSERT INTO art VALUES (1730, 57002, 'Sand', 'Personenfährverkehr', '''Personenfährverkehr'' ist ein in der Regel nach festem Fahrplan über Flüsse, Seen, Kanäle, Meerengen oder Meeresarme stattfindender Schiffsverkehr zwischen zwei Anlegestellen für Personenbeförderung.');
INSERT INTO art VALUES (1740, 57002, 'Sand', 'Linienverkehr', '''Linienverkehr'' ist die auf einer festgelegten Route nach einem festen Fahrplan verkehrende Güter- und Personenschifffahrt.');
INSERT INTO art VALUES (1910, 61003, 'Sand', 'Hochwasserdeich', '''Hochwasserdeich'' ist ein Deich an einem Fliessgewässer oder im Küstengebiet, der dem Schutz eines Gebietes vor Hochwasser oder gegen Sturmfluten dient.');
INSERT INTO art VALUES (1920, 61003, 'Sand', 'Hauptdeich, Landesschutzdeich', '''Hauptdeich, Landesschutzdeich'' ist ein Deich der ersten Deichlinie zum Schutz der Küsten- und Inselgebiete gegen Sturmflut.');
INSERT INTO art VALUES (1940, 61003, 'Sand', 'Überlaufdeich', '''Überlaufdeich'' ist ein Deich vor dem Hauptdeich, der in erster Linie dem Schutz landwirtschaftlich genutzter Flächen gegen leichte Sturmtiden dient und der bei höheren Sturmtiden überströmt wird.');
INSERT INTO art VALUES (1950, 61003, 'Sand', 'Leitdeich', '''Leitdeich'' ist ein dammartiges Bauwerk im Watt, um strömendes Wasser in bestimmte Richtungen zu lenken und zum Schutz von Wasserläufen im Watt (Außentiefs) vor Versandung.');
INSERT INTO art VALUES (1960, 61003, 'Sand', 'Polderdeich', '''Polderdeich'' ist ein vor dem Hauptdeich liegender Deich, der landwirtschaftlich nutzbares Land (z. B. Marschland) schützt.');
INSERT INTO art VALUES (1970, 61003, 'Sand', 'Schlafdeich', '''Schlafdeich'' ist ein ehemaliger Hauptdeich, der infolge einer Vorverlegung der Deichlinie zu einem Binnendeich geworden ist und keine unmittelbare Schutzaufgabe mehr zu erfüllen hat.');
INSERT INTO art VALUES (1980, 61003, 'Sand', 'Mitteldeich', '''Mitteldeich'' ist ein Deich der 2. Deichlinie, auch an größeren Flüssen. Er soll Überschwemmungen beim Bruch des Deiches der ersten Deichlinie verhindern.');
INSERT INTO art VALUES (1980, 61003, 'Sand', 'Binnendeich', '''Binnendeich'' ist ein Deich an kleineren Wasserläufen, der Überschwemmungen durch ablaufendes Oberflächenwasser verhindern soll.');
INSERT INTO art VALUES (1990, 61003, 'Sand', 'Wall', '''Wall'' ist ein meist künstlich aus Erde und Feldsteinen oder Torf errichtetes, langgestrecktes und schmales Landschaftselement, das oft ein- oder beidseitig von Aushubgräben begleitet wird und keinen nennenswerten Bewuchs trägt.');
INSERT INTO art VALUES (1991, 61003, 'Sand', 'Wallkante, rechts', '');
INSERT INTO art VALUES (1992, 61003, 'Sand', 'Wallkante, links', '');
INSERT INTO art VALUES (1993, 61003, 'Sand', 'Wallmitte', '');
INSERT INTO art VALUES (2000, 61003, 'Sand', 'Knick', '''Knick'' oder auch ''Wallhecke'' ist ein Wall, der mit Sträuchern in Heckenform und einzeln stehenden Bäumen bewachsen ist. Knicks sind landschaftsprägend und können der Grenzmarkierung, Einfriedung und dem Schutz gegen Winderosion dienen.');
INSERT INTO art VALUES (2001, 61003, 'Sand', 'Knickkante, rechts', '');
INSERT INTO art VALUES (2002, 61003, 'Sand', 'Knickkante, links', '');
INSERT INTO art VALUES (2003, 61003, 'Sand', 'Knickmitte', '');
INSERT INTO art VALUES (2010, 61003, 'Sand', 'Graben mit Wall, rechts', '');
INSERT INTO art VALUES (2011, 61003, 'Sand', 'Graben mit Wall, links', '');
INSERT INTO art VALUES (2012, 61003, 'Sand', 'Graben mit Knick, rechts', '');
INSERT INTO art VALUES (2013, 61003, 'Sand', 'Graben mit Knick, links', '');
INSERT INTO art VALUES (1000, 62010, 'Sand', 'Unklassifizierte Punkte', '''Unklassifizierte Punkte'' sind nicht spezifizierte Höhenpunkte.');
INSERT INTO art VALUES (1100, 62010, 'Sand', 'Geländepunkte, allgemein', '''Geländepunkte'' sind nicht näher spezifizierte Höhenpunkte auf dem Gelände als auch in trockengefallenen Gewässer-/Wattflächen.');
INSERT INTO art VALUES (1110, 62010, 'Sand', 'Feinklassifizierte Geländepunkte', '''Feinklassifizierte Geländepunkte'' sind verifizierte Höhenpunkte auf dem Gelände als auch in trockengefallenen Gewässer-/Wattflächen.');
INSERT INTO art VALUES (1120, 62010, 'Sand', 'Geländepunkte ohne Keller', '''Geländepunkte ohne Keller'' sind Höhenpunkte auf dem Gelände als auch in trockengefallenen Gewässer-/Wattflächen, die nicht in einem (Keller-)Abgang oder Lichtschacht liegen.');
INSERT INTO art VALUES (1130, 62010, 'Sand', 'Gewässerpunkte', '''Gewässerpunkte'' sind nicht näher spezifizierte Höhenpunkte auf einem Gewässer.');
INSERT INTO art VALUES (1200, 62010, 'Sand', 'Nicht-Geländepunkte, allgemein', '''Nicht-Geländepunkte'' sind nicht näher spezifizierte Höhenpunkte, die nicht auf dem Gelände liegen.');
INSERT INTO art VALUES (1210, 62010, 'Sand', 'Tiefpunkte, Rauschen', '''Tiefpunkte'' sind nicht näher spezifizierte Höhenpunkte, die unterhalb des Geländes liegen und durch Fehlmessungen (Multipath-Effekt) entstanden sind.');
INSERT INTO art VALUES (1220, 62010, 'Sand', 'Hochpunkte, Rauschen', '''Hochpunkte'' sind nicht näher spezifizierte Höhenpunkte, die kein Oberflächenobjekt beschreiben und durch Fehlmessungen (z. B.: Vögel, Nebel, Wolken, etc.) entstanden sind.');
INSERT INTO art VALUES (1300, 62010, 'Sand', 'Bauwerkspunkte, allgemein', '''Bauwerkspunkte'' sind nicht näher spezifizierte Höhenpunkte auf einem Bauwerk.');
INSERT INTO art VALUES (1310, 62010, 'Sand', 'Gebäudepunkte', '''Gebäudepunkte'' sind nicht näher spezifizierte Höhenpunkte auf einem Gebäude.');
INSERT INTO art VALUES (1315, 62010, 'Sand', 'Gebäudeinstallationspunkte', '''Gebäudeinstallationspunkte'' sind Höhenpunkte, auf einer Gebäudeinstallation (z.B.: Antenne, Schornstein, etc.).');
INSERT INTO art VALUES (1318, 62010, 'Sand', 'Kellerpunkte', '''Kellerpunkte'' sind Höhenpunkte, die in einem Keller-/Abgang oder Lichtschacht liegen.');
INSERT INTO art VALUES (1320, 62010, 'Sand', 'Brückenpunkte', '''Brückenpunkte'' sind nicht näher spezifizierte Höhenpunkte auf einem Brückenbauwerk, die die eigentliche Brückenüberführung beschreiben.');
INSERT INTO art VALUES (1325, 62010, 'Sand', 'Brückenfundamentpunkte', '''Brückenfundamentpunkte'' sind Höhenpunkte, die das Brückenfundament sowie Pfeiler und Widerlager beschreiben.');
INSERT INTO art VALUES (1330, 62010, 'Sand', 'Wasserbauwerkspunkte', '''Wasserbauwerkspunkte'' sind Höhenpunkte, die ein Wasserbauwerk wie z. B. Buhnen, Parallelwerke, Leitdämme, nicht bewegliche Bauteile von Anlegebrücken, Sperrwerken und Schleusen, Wehre, Leuchtfeuer, etc. beschreiben.');
INSERT INTO art VALUES (1340, 62010, 'Sand', 'Straßenpunkte', '''Straßenpunkte'' sind nicht näher spezifizierte Höhenpunkte auf einer Straße.');
INSERT INTO art VALUES (1350, 62010, 'Sand', 'Bahnkörperpunkte', '''Bahnkörperpunkte'' sind nicht näher spezifizierte Höhenpunkte auf einem Bahnkörper (Schotterung).');
INSERT INTO art VALUES (1400, 62010, 'Sand', 'Vegetationspunkte, allgemein', '''Vegetationspunkte'' sind nicht näher spezifizierte Höhenpunkte auf der Vegetation.');
INSERT INTO art VALUES (1401, 62010, 'Sand', 'Vegetationspunkte, niedrige Vegetation', '''Vegetationspunkte, niedrige Vegetation'' sind nicht näher spezifizierte Höhenpunkte auf der Vegetation mit einer Höhe bis 1,5 Meter über dem Gelände.');
INSERT INTO art VALUES (1402, 62010, 'Sand', 'Vegetationspunkte, mittel hohe Vegetation', '''Vegetationspunkte, mittelhohe Vegetation'' sind nicht näher spezifizierte Höhenpunkte auf der Vegetation mit einer Höhe ab 1,5 Meter bis 8 Meter über dem Gelände.');
INSERT INTO art VALUES (1403, 62010, 'Sand', 'Vegetationspunkte, hohe Vegetation', '''Vegetationspunkte, hohe Vegetation '' sind nicht näher spezifizierte Höhenpunkte auf der Vegetation mit einer Höhe ab 8 Meter über dem Gelände.');
INSERT INTO art VALUES (1500, 62010, 'Sand', 'Energieversorgungspunkte, allgemein', '''Energieversorgungspunkte'' sind nicht näher spezifizierte Höhenpunkte auf einem Energieversorgungsobjekt.');
INSERT INTO art VALUES (1501, 62010, 'Sand', 'Leitungsschutzpunkte', '''Leitungsschutzpunkte'' sind Höhenpunkte auf einem Leitungsschutz.');
INSERT INTO art VALUES (1502, 62010, 'Sand', 'Leitungsdrahtpunkte', '''Leitungsdrahtpunkte'' sind Höhenpunkte auf einem Leitungsdraht.');
INSERT INTO art VALUES (1503, 62010, 'Sand', 'Fernleitungsmastpunkte', '''Fernleitungsmastpunkte'' sind Höhenpunkte auf einem Fernleitungsmast.');
INSERT INTO art VALUES (1504, 62010, 'Sand', 'Fernleitungsinfrastrukturpunkte', '''Fernleitungsinfrastrukturpunkte'' sind nicht näher spezifizierte Höhenpunkte auf einem Fernleitungsinfrastrukturobjekt wie z. B. einem Isolator, etc.');
INSERT INTO art VALUES (1010, 62020, 'Sand', 'Markanter Geländepunkt', '''Markanter Geländepunkt'' ist ein charakteristischer Höhenpunkt an markanten Geländestellen.');
INSERT INTO art VALUES (1020, 62020, 'Sand', 'Kuppenpunkt', '''Kuppenpunkt'' ist ein charakteristischer Höhenpunkt an der höchsten Stelle einer rundlichen Einzelerhebung.');
INSERT INTO art VALUES (1030, 62020, 'Sand', 'Kesselpunkt', '''Kesselpunkt'' ist ein charakteristischer Höhenpunkt an der tiefsten Stelle einer rundlichen Vertiefung.');
INSERT INTO art VALUES (1040, 62020, 'Sand', 'Sattelpunkt', '''Sattelpunkt'' ist ein charakteristischer Höhenpunkt im Schnittpunkt einer Rücken und Muldenlinie.');
INSERT INTO art VALUES (1100, 62020, 'Sand', 'Besonderer Höhenpunkt', '''Besonderer Höhenpunkt'' ist ein charakteristischer Höhenpunkt.');
INSERT INTO art VALUES (1110, 62020, 'Sand', 'Höhenpunkt auf Wasserfläche', '''Höhenpunkt auf Wasserfläche'' ist ein charakteristischer Höhenpunkt auf einer Wasserfläche.');
INSERT INTO art VALUES (1120, 62020, 'Sand', 'Wegepunkt', '''Wegepunkt'' ist ein charakteristischer Höhenpunkt auf einem Weg oder einer Straße.');
INSERT INTO art VALUES (1210, 62020, 'Sand', 'Strukturiert erfasster Geländepunkt', '''Strukturiert erfasster Geländepunkt'' ist ein Geländepunkt, der nach einem bestimmten Kriterium erfasst wurde.');
INSERT INTO art VALUES (1220, 62020, 'Sand', 'Gemessener Höhenlinienpunkt', '''Gemessener Höhenlinienpunkt'' ist ein gemessener Höhenpunkt innerhalb einer Höhenlinie.');
INSERT INTO art VALUES (1230, 62020, 'Sand', 'Dynamisch gemessener Höhenprofilpunkt', '''Dynamisch gemessener Höhenlinienprofilpunkt'' ist ein gemessener Höhenpunkt innerhalb eines Höhenprofils.');
INSERT INTO art VALUES (1100, 62030, 'Sand', 'Gewässerbegrenzung', '''Gewässerbegrenzung'' ist die Linie, welche ein Gewässer zum Ufer hin abgrenzt.');
INSERT INTO art VALUES (1200, 62030, 'Sand', 'Geländekante, allgemein', '''Geländekante, allgemein'' ist die einzelne Kante unterschiedlich geneigter Geländeflächen und keine Obergruppe anderer Geländekanten.');
INSERT INTO art VALUES (1210, 62030, 'Sand', 'Steilrand, Kliffkante', '''Steilrand, Kliffkante'' begrenzt den von der Brandung beständig abgetragenen Steilhang einer Küste.');
INSERT INTO art VALUES (1220, 62030, 'Sand', 'Oberkante', '''Oberkante'' ist die obere Kante eines ZUSO Böschung, Kliff oder eines Bauwerkes wie z. B. Kai- oder Stützmauer.');
INSERT INTO art VALUES (1230, 62030, 'Sand', 'Unterkante', '''Unterkante'' ist die untere Kante eines ZUSO Böschung, Kliff oder eines Bauwerkes wie z. B. Kai- oder Stützmauer.');
INSERT INTO art VALUES (1240, 62030, 'Sand', 'Sonstige Begrenzungskante', '''Sonstige Begrenzungskante'' sind alle Kanten, die nicht anderen Kanten zugeordnet werden können (z. B. Trennschraffe).');
INSERT INTO art VALUES (1250, 62030, 'Sand', 'Oberkante zugleich Unterkante', '''Oberkante zugleich Unterkante'' beschreibt den Wechsel der Böschungsneigung (Gefällewechsel) innerhalb von ZUSO Böschung, Kliff.');
INSERT INTO art VALUES (1300, 62030, 'Sand', 'Geripplinie', '''Geripplinie'' ist eine Falllinie, welche zur Erfassung von Rücken und Mulden erforderlich ist.');
INSERT INTO art VALUES (1310, 62030, 'Sand', 'Muldenlinie', '''Muldenlinie'' ist die tiefste Linie einer Mulde.');
INSERT INTO art VALUES (1311, 62030, 'Sand', 'Wasserführende Muldenlinie', '''Wasserführende Muldenlinie '' ist die tiefste Linie einer Mulde, die Wasser führt.');
INSERT INTO art VALUES (1320, 62030, 'Sand', 'Rückenlinie', '''Rückenlinie'' ist die höchste Linie bei lang gestreckten Bergrücken, welche die Wasserscheide bildet.');
INSERT INTO art VALUES (1400, 62030, 'Sand', 'Bauwerksbegrenzungslinie', '''Bauwerksbegrenzungslinie'' ist die Linie, welche ein Bauwerk zur umliegenden Umgebung hin abgrenzt.');
INSERT INTO art VALUES (1410, 62030, 'Sand', 'Brückenbegrenzungslinie', '''Brückenbegrenzungslinie'' ist die Linie, welche eine Brücke zur umliegenden Umgebung hin abgrenzt.');
INSERT INTO art VALUES (1420, 62030, 'Sand', 'Tunnelbegrenzungslinie', '''Tunnelbegrenzungslinie'' ist die Linie, welche ein Tunnelportal zur umliegenden Umgebung hin abgrenzt.');
INSERT INTO art VALUES (1000, 62040, 'Sand', 'Aussparungsfläche', '''Aussparungsfläche'' ist eine Fläche, die bei der DHM-Bearbeitung nicht berücksichtigt wird.');
INSERT INTO art VALUES (1010, 62040, 'Sand', 'DGM-Aussparungsfläche', '''DGM-Aussparungsfläche'' ist eine Fläche, die bei der DGM-Bearbeitung nicht berücksichtigt wird.');
INSERT INTO art VALUES (1020, 62040, 'Sand', 'DOM-Aussparungsfläche', '''DOM-Aussparungsfläche'' ist eine Fläche, die bei der DOM-Bearbeitung nicht berücksichtigt wird.');
INSERT INTO art VALUES (1030, 62040, 'Sand', 'Kartographische Aussparungsfläche', '''Kartographische Aussparungsfläche'' ist eine Fläche, die bei der kartographischen Bearbeitung nicht berücksichtigt wird.');
INSERT INTO art VALUES (1040, 62040, 'Sand', 'Brückenbegrenzungsfläche', '''Brückenbegrenzungsfläche'' ist eine Fläche, die bei der Bearbeitung von Brücken-DGM berücksichtigt wird.');
INSERT INTO art VALUES (1000, 73012, 'Sand', 'Planungsverband', '');
INSERT INTO art VALUES (2000, 73012, 'Sand', 'Region', '');
INSERT INTO art VALUES (9999, 73012, 'Other', 'Sonstiges', '');
INSERT INTO art VALUES (1100, 75001, 'Sand', 'Nettobaublockfläche', '');
INSERT INTO art VALUES (2000, 75001, 'Sand', 'Bruttobaublockfläche', '');
INSERT INTO art VALUES (1000, 81005, 'Sand', 'Stichtagsbezogen ohne Historie', '''Stichtagsbezogen ohne Historie'' selektiert die Differenzdaten zwischen letzter erfolgreicher Datenabgabe und Stichzeitpunkt, in der Sekundärdatenbank ist stets nur der aktuelle Stand der Daten verfügbar.');
INSERT INTO art VALUES (1100, 81005, 'Sand', 'Stichtagsbezogen mit Historie', '''Stichtagsbezogen mit Historie'' selektiert die Differenzdaten zwischen letzter erfolgreicher Datenabgabe und Stichzeitpunkt, in der Sekundärdatenbank werden zumindest temporär auch untergegangene Objekte und Objektversionen vorgehalten.');
INSERT INTO art VALUES (3000, 81005, 'Sand', 'Fallbezogen ohne Historie', '''Fallbezogen ohne Historie'' selektiert alle Änderungen zwischen letzter erfolgreicher Datenabgabe und Stichzeitpunkt, in der Sekundärdatenbank ist stets nur der aktuelle Stand der Daten verfügbar.');
INSERT INTO art VALUES (3100, 81005, 'Sand', 'Fallbezogen mit Historie', '''Fallbezogen mit Historie'' selektiert alle Änderungen zwischen letzter erfolgreicher Datenabgabe und Stichzeitpunkt, in der Sekundärdatenbank werden zumindest temporär auch untergegangene Objekte und Objektversionen vorgehalten.');
INSERT INTO art VALUES (1000, 96007, 'Sand', 'Punktkennung', '');
INSERT INTO art VALUES (1300, 96007, 'Sand', 'Punktkennung - Grenzpunkt', '');
INSERT INTO art VALUES (1400, 96007, 'Sand', 'Punktkennung - Besonderer Gebäudepunkt', '');
INSERT INTO art VALUES (1500, 96007, 'Sand', 'Punktkennung - Besonderer topographischer Punkt', '');
INSERT INTO art VALUES (1600, 96007, 'Sand', 'Punktkennung - Besonderer Bauwerkspunkt', '');
INSERT INTO art VALUES (1700, 96007, 'Sand', 'Punktkennung - Aufnahmepunkt', '');
INSERT INTO art VALUES (1800, 96007, 'Sand', 'Punktkennung - Sicherungspunkt', '');
INSERT INTO art VALUES (1900, 96007, 'Sand', 'Punktkennung - Sonstiger Vermessungspunkt', '');
INSERT INTO art VALUES (2000, 96007, 'Sand', 'Punktkennung - Lagefestpunkt', '');
INSERT INTO art VALUES (2100, 96007, 'Sand', 'Punktkennung - Höhenfestpunkt', '');
INSERT INTO art VALUES (2200, 96007, 'Sand', 'Punktkennung - Schwerefestpunkt', '');
INSERT INTO art VALUES (2300, 96007, 'Sand', 'Punktkennung - Referenzstationspunkt', '');
INSERT INTO art VALUES (3000, 96007, 'Sand', 'Flurstückskennzeichen', 'Eine Reservierung von Folgenummern zu einer Nummer darf sich nur auf aktuelle Flurstücke 11001 beziehen und nicht auf dauerhaft reservierte ausfallende Nummern, die keine aktuellen Flurstücke haben.');
INSERT INTO art VALUES (4000, 96007, 'Sand', 'FN-Nummer', '');
INSERT INTO art VALUES (5000, 96007, 'Sand', 'Abmarkungsprotokollnummer', '');
INSERT INTO art VALUES (6000, 96007, 'Sand', 'Buchungsblattkennzeichen', '');
INSERT INTO art VALUES (6100, 96007, 'Sand', 'Katasterblatt', '');
INSERT INTO art VALUES (6200, 96007, 'Sand', 'Pseudoblatt', '');
INSERT INTO art VALUES (6300, 96007, 'Sand', 'Erwerberblatt', '');
INSERT INTO art VALUES (6400, 96007, 'Sand', 'Fiktives Blatt', '');
INSERT INTO art VALUES (1000, 96008, 'Sand', 'Punktkennung', '');
INSERT INTO art VALUES (1300, 96008, 'Sand', 'Punktkennung - Grenzpunkt', '');
INSERT INTO art VALUES (1400, 96008, 'Sand', 'Punktkennung - Besonderer Gebäudepunkt', '');
INSERT INTO art VALUES (1500, 96008, 'Sand', 'Punktkennung - Besonderer topographischer Punkt', '');
INSERT INTO art VALUES (1600, 96008, 'Sand', 'Punktkennung - Besonderer Bauwerkspunkt', '');
INSERT INTO art VALUES (1700, 96008, 'Sand', 'Punktkennung - Aufnahmepunkt', '');
INSERT INTO art VALUES (1800, 96008, 'Sand', 'Punktkennung - Sicherungspunkt', '');
INSERT INTO art VALUES (1900, 96008, 'Sand', 'Punktkennung - Sonstiger Vermessungspunkt', '');
INSERT INTO art VALUES (2000, 96008, 'Sand', 'Punktkennung - Lagefestpunkt', '');
INSERT INTO art VALUES (2100, 96008, 'Sand', 'Punktkennung - Höhenfestpunkt', '');
INSERT INTO art VALUES (2200, 96008, 'Sand', 'Punktkennung - Schwerefestpunkt', '');
INSERT INTO art VALUES (2300, 96008, 'Sand', 'Punktkennung - Referenzstationspunkt', '');
INSERT INTO art VALUES (3000, 96008, 'Sand', 'Flurstückskennzeichen', 'Eine Reservierung von Folgenummern zu einer Nummer darf sich nur auf aktuelle Flurstücke 11001 beziehen und nicht auf dauerhaft reservierte ausfallende Nummern, die keine aktuellen Flurstücke haben.');
INSERT INTO art VALUES (4000, 96008, 'Sand', 'FN-Nummer', '');
INSERT INTO art VALUES (5000, 96008, 'Sand', 'Abmarkungsprotokollnummer', '');
INSERT INTO art VALUES (6000, 96008, 'Sand', 'Buchungsblattkennzeichen', '');
INSERT INTO art VALUES (6100, 96008, 'Sand', 'Katasterblatt', '');
INSERT INTO art VALUES (6200, 96008, 'Sand', 'Pseudoblatt', '');
INSERT INTO art VALUES (6300, 96008, 'Sand', 'Erwerberblatt', '');
INSERT INTO art VALUES (6400, 96008, 'Sand', 'Fiktives Blatt', '');
INSERT INTO art VALUES (0050, 08110, 'Sand', 'Änderungsdatensätze an Justizverwaltung', '');
INSERT INTO art VALUES (0010, 08110, 'Sand', 'Bestandsdatenauszug', 'Der ''Bestandsdatenauszug'' enthält alle Objekte, die aufgrund der Auswertung des Attributes ''Anforderungsmerkmale'' der Prozess-Objektart ''Benutzungsauftrag'' aus den Bestandsdaten selektiert werden.');
INSERT INTO art VALUES (0060, 08110, 'Sand', 'Bestandsdatenauszug Basis-DLM', '''Bestandsdatenauszug Basis-DLM'' ist ein ''Bestandsdatenauszug'' aus dem Basis-DLM.');
INSERT INTO art VALUES (0090, 08110, 'Sand', 'Bestandsdatenauszug DHM', '');
INSERT INTO art VALUES (0063, 08110, 'Sand', 'Bestandsdatenauszug DLM1000', '');
INSERT INTO art VALUES (0062, 08110, 'Sand', 'Bestandsdatenauszug DLM250', '');
INSERT INTO art VALUES (0061, 08110, 'Sand', 'Bestandsdatenauszug DLM50', '''Bestandsdatenauszug DLM50'' ist ein ''Bestandsdatenauszug'' aus dem DLM50.');
INSERT INTO art VALUES (0080, 08110, 'Sand', 'Bestandsdatenauszug DTK10', '');
INSERT INTO art VALUES (0083, 08110, 'Sand', 'Bestandsdatenauszug DTK100', '');
INSERT INTO art VALUES (0085, 08110, 'Sand', 'Bestandsdatenauszug DTK1000', '');
INSERT INTO art VALUES (0081, 08110, 'Sand', 'Bestandsdatenauszug DTK25', '');
INSERT INTO art VALUES (0084, 08110, 'Sand', 'Bestandsdatenauszug DTK250', '');
INSERT INTO art VALUES (0082, 08110, 'Sand', 'Bestandsdatenauszug DTK50', '');
INSERT INTO art VALUES (0086, 08110, 'Sand', 'Bestandsdatenauszug TFIS25', '');
INSERT INTO art VALUES (0087, 08110, 'Sand', 'Bestandsdatenauszug TFIS50', '');
INSERT INTO art VALUES (0065, 08110, 'Sand', 'Bestandsdatenauszug - Grunddatenbestand - Basis-DLM', '''Bestandsdatenauszug - Grunddatenbestand - Basis-DLM'' ist ein ''Bestandsdatenauszug'' aus dem Grunddatenbestand des Basis-DLM.');
INSERT INTO art VALUES (0066, 08110, 'Sand', 'Bestandsdatenauszug - Grunddatenbestand - DLM50', '');
INSERT INTO art VALUES (0700, 08110, 'Sand', 'Bestandsnachweis', '');
INSERT INTO art VALUES (0701, 08110, 'Sand', 'Bestandsnachweis - Grunddatenbestand', '');
INSERT INTO art VALUES (4075, 08110, 'Sand', 'Einzelnachweis Geodätischer Grundnetzpunkt', '');
INSERT INTO art VALUES (4050, 08110, 'Sand', 'Einzelnachweis Höhenfestpunkt', '');
INSERT INTO art VALUES (4040, 08110, 'Sand', 'Einzelnachweis Lagefestpunkt', '');
INSERT INTO art VALUES (4070, 08110, 'Sand', 'Einzelnachweis Referenzstationspunkt', '');
INSERT INTO art VALUES (4060, 08110, 'Sand', 'Einzelnachweis Schwerefestpunkt', '');
INSERT INTO art VALUES (1121, 08110, 'Sand', 'Flurstücks-, Bodenschätzungs- und Eigentümerangaben', '');
INSERT INTO art VALUES (1111, 08110, 'Sand', 'Flurstücks- und Eigentümerangaben (ohne Bodenschätzung)', '');
INSERT INTO art VALUES (0550, 08110, 'Sand', 'Flurstücks- und Eigentumsnachweis', '');
INSERT INTO art VALUES (0560, 08110, 'Sand', 'Flurstücks- und Eigentumsnachweis mit Bodenschätzung', '');
INSERT INTO art VALUES (0561, 08110, 'Sand', 'Flurstücks- und Eigentumsnachweis mit Bodenschätzung - Grunddatenbestand', '');
INSERT INTO art VALUES (0551, 08110, 'Sand', 'Flurstücks- und Eigentumsnachweis - Grunddatenbestand', '');
INSERT INTO art VALUES (0510, 08110, 'Sand', 'Flurstücksnachweis', '');
INSERT INTO art VALUES (0520, 08110, 'Sand', 'Flurstücksnachweis mit Bodenschätzung', '');
INSERT INTO art VALUES (0521, 08110, 'Sand', 'Flurstücksnachweis mit Bodenschätzung - Grunddatenbestand', '');
INSERT INTO art VALUES (0511, 08110, 'Sand', 'Flurstücksnachweis - Grunddatenbestand', '');
INSERT INTO art VALUES (1222, 08110, 'Sand', 'Fortführungsmitteilung an Eigentümer (ohne Eigentümerangaben)', '');
INSERT INTO art VALUES (1223, 08110, 'Sand', 'Fortführungsmitteilung an Eigentümer (mit Eigentümerangaben)', '');
INSERT INTO art VALUES (1212, 08110, 'Sand', 'Fortführungsnachweis (ohne Eigentümerangaben)', '');
INSERT INTO art VALUES (1213, 08110, 'Sand', 'Fortführungsnachweis (mit Eigentümerangaben)', '');
INSERT INTO art VALUES (1220, 08110, 'Sand', 'Fortführungsmitteilung an Eigentümer', '');
INSERT INTO art VALUES (1230, 08110, 'Sand', 'Fortführungsmitteilung an Finanzverwaltung', '');
INSERT INTO art VALUES (1250, 08110, 'Sand', 'Fortführungsmitteilung an Justizverwaltung', '');
INSERT INTO art VALUES (1210, 08110, 'Sand', 'Fortführungsnachweis bei Fortführung', 'Dieser Benutzungsanlass ist nicht für manuelle Nutzung konzipiert, sondern er wird im Rahmen der Fortführungsverarbeitung automatisiert angestoßen.');
INSERT INTO art VALUES (1211, 08110, 'Sand', 'Fortführungsnachweis nachträglich angefordert', '');
INSERT INTO art VALUES (0900, 08110, 'Sand', 'Gebäudenachweis', '');
INSERT INTO art VALUES (0800, 08110, 'Sand', 'Georeferenzierte Gebäudeadresse', '');
INSERT INTO art VALUES (0600, 08110, 'Sand', 'Grundstücksnachweis', '');
INSERT INTO art VALUES (0601, 08110, 'Sand', 'Grundstücksnachweis - Grunddatenbestand', '');
INSERT INTO art VALUES (0110, 08110, 'Sand', 'Liegenschaftskarte', '');
INSERT INTO art VALUES (0120, 08110, 'Sand', 'Liegenschaftskarte mit Bodenschätzung', '');
INSERT INTO art VALUES (1120, 08110, 'Sand', 'Liegenschaftskarte mit Bodenschätzung und Eigentümerangaben', '');
INSERT INTO art VALUES (0121, 08110, 'Sand', 'Liegenschaftskarte mit Bodenschätzung - Grunddatenbestand', '');
INSERT INTO art VALUES (1110, 08110, 'Sand', 'Liegenschaftskarte mit Flurstücks- und Eigentümerangaben (ohne Bodenschätzung)', '');
INSERT INTO art VALUES (1020, 08110, 'Sand', 'Liegenschaftskarte mit Punktnummern', '');
INSERT INTO art VALUES (1000, 08110, 'Sand', 'Liegenschaftskarte mit Punktnummern und Punktliste', '');
INSERT INTO art VALUES (0111, 08110, 'Sand', 'Liegenschaftskarte - Grunddatenbestand', '');
INSERT INTO art VALUES (2300, 08110, 'Sand', 'Liste der reservierten Fachkennzeichen', '');
INSERT INTO art VALUES (2332, 08110, 'Sand', 'Liste der reservierten Fachkennzeichen - Abmarkungsprotokollnummer', '');
INSERT INTO art VALUES (2331, 08110, 'Sand', 'Liste der reservierten Fachkennzeichen - Fortführungsnachweisnummer', '');
INSERT INTO art VALUES (2334, 08110, 'Sand', 'Liste der reservierten Fachkennzeichen - Punktkennung - Folgepunktnummer', '');
INSERT INTO art VALUES (2333, 08110, 'Sand', 'Liste der reservierten Fachkennzeichen - Punktkennung - Leitpunktnummer', '');
INSERT INTO art VALUES (2320, 08110, 'Sand', 'Liste der reservierten Fachkennzeichen: Flurstückskennzeichen', '');
INSERT INTO art VALUES (2310, 08110, 'Sand', 'Liste der reservierten Fachkennzeichen: Punktkennung - allgemein', '');
INSERT INTO art VALUES (2315, 08110, 'Sand', 'Liste der reservierten Fachkennzeichen: Punktkennung - Aufnahmepunkt', '');
INSERT INTO art VALUES (2318, 08110, 'Sand', 'Liste der reservierten Fachkennzeichen: Punktkennung - Besonderer Bauwerkspunkt', '');
INSERT INTO art VALUES (2312, 08110, 'Sand', 'Liste der reservierten Fachkennzeichen: Punktkennung - Besonderer Gebäudepunkt', '');
INSERT INTO art VALUES (2314, 08110, 'Sand', 'Liste der reservierten Fachkennzeichen: Punktkennung - Besonderer topographischer Punkt', '');
INSERT INTO art VALUES (2311, 08110, 'Sand', 'Liste der reservierten Fachkennzeichen: Punktkennung - Grenzpunkt', '');
INSERT INTO art VALUES (2316, 08110, 'Sand', 'Liste der reservierten Fachkennzeichen: Punktkennung - Sicherungspunkt', '');
INSERT INTO art VALUES (2317, 08110, 'Sand', 'Liste der reservierten Fachkennzeichen: Punktkennung - Sonstiger Vermessungspunkt', '');
INSERT INTO art VALUES (1050, 08110, 'Sand', 'Nachweis der Aufnahmepunkte', '');
INSERT INTO art VALUES (0040, 08110, 'Sand', 'Nutzerbezogene Bestandsdatenaktualisierung (NBA)', '''Nutzerbezogene Bestandsdatenaktualisierung (NBA)'' dient der Führung von Sekundärdatenbeständen mittels Datenerstausstattung und nachfolgender differenzieller Updates (stichtags- oder fallbezogen). Der Dateninhalt entspricht der festgelegten räumlichen und/oder semantischen Selektion aus dem Gesamtdatenbestand.');
INSERT INTO art VALUES (0075, 08110, 'Sand', 'Nutzerbezogene Bestandsdatenaktualisierung (NBA) DLM1000', '');
INSERT INTO art VALUES (0074, 08110, 'Sand', 'Nutzerbezogene Bestandsdatenaktualisierung (NBA) DLM250', '');
INSERT INTO art VALUES (0070, 08110, 'Sand', 'Nutzerbezogener Bestandsdatenaktualisierung (NBA) Basis-DLM', '''Nutzerbezogene Bestandsdatenaktualisierung (NBA) Basis-DLM'' ist eine ''NBA'' aus dem Basis-DLM.');
INSERT INTO art VALUES (0071, 08110, 'Sand', 'Nutzerbezogener Bestandsdatenaktualisierung (NBA) DLM50', '');
INSERT INTO art VALUES (0072, 08110, 'Sand', 'Nutzerbezogener Bestandsdatenaktualisierung (NBA) - Grundatenbestand - Basis-DLM', '''Nutzerbezogene Bestandsdatenaktualisierung (NBA) - Grunddatenbestand - Basis-DLM'' ist eine ''NBA'' aus dem Grunddatenbestand des Basis-DLM.');
INSERT INTO art VALUES (0073, 08110, 'Sand', 'Nutzerbezogener Bestandsdatenaktualisierung (NBA) - Grunddatenbestand - DLM50', '');
INSERT INTO art VALUES (1010, 08110, 'Sand', 'Punktliste', '');
INSERT INTO art VALUES (4035, 08110, 'Sand', 'Punktliste Geodätische Grundnetzpunkte', '');
INSERT INTO art VALUES (4010, 08110, 'Sand', 'Punktliste Höhenfestpunkte', '');
INSERT INTO art VALUES (4000, 08110, 'Sand', 'Punktliste Lagefestpunkte', '');
INSERT INTO art VALUES (4030, 08110, 'Sand', 'Punktliste Referenzstationspunkte', '');
INSERT INTO art VALUES (4020, 08110, 'Sand', 'Punktliste Schwerefestpunkte', '');
INSERT INTO art VALUES (2170, 08110, 'Sand', 'Amtliche Flächenstatistik', '');
INSERT INTO art VALUES (2210, 08110, 'Sand', 'Statistik der Flächen nach dem Bewertungsgesetz (Aggregationseinheit: Gemarkung)', '');
INSERT INTO art VALUES (2211, 08110, 'Sand', 'Statistik der Flächen nach dem Bewertungsgesetz (Aggregationseinheit: Gemarkung + Stichtag)', 'Der Stichtag wird im Benutzungsauftrag über das ''lebenszeitintervall’ der Gemarkung ausgedrückt und übermittelt.');
INSERT INTO art VALUES (2400, 08110, 'Sand', 'Vergleichendes Punktnummernverzeichnis', '');
INSERT INTO art VALUES (2402, 08110, 'Sand', 'VPN sortiert nach endgültigen Punktkennzeichen', '');
INSERT INTO art VALUES (2401, 08110, 'Sand', 'VPN sortiert nach vorläufigen Punktkennzeichen', '');
INSERT INTO art VALUES (1000, 08400, 'Sand', 'alleObjekte', 'Diese Werteart bedeutet eine zwingende Themenbildung. Dabei sind alle in der Themendefinition genannten Objektarten Bestandteil des Themas und die Objektarten teilen sich stets die Geometrien.');

ALTER TABLE "ver04_f" ADD CONSTRAINT art_fk FOREIGN KEY (art, objart) REFERENCES art(code, objart);
ALTER TABLE "ver05_l" ADD CONSTRAINT art_fk FOREIGN KEY (art, objart) REFERENCES art(code, objart);
ALTER TABLE "ver06_l" ADD CONSTRAINT art_fk FOREIGN KEY (art, objart) REFERENCES art(code, objart);
ALTER TABLE "ver06_p" ADD CONSTRAINT art_fk FOREIGN KEY (art, objart) REFERENCES art(code, objart);
ALTER TABLE "gew02_f" ADD CONSTRAINT art_fk FOREIGN KEY (art, objart) REFERENCES art(code, objart);
ALTER TABLE "gew02_p" ADD CONSTRAINT art_fk FOREIGN KEY (art, objart) REFERENCES art(code, objart);
ALTER TABLE "rel01_l" ADD CONSTRAINT art_fk FOREIGN KEY (art, objart) REFERENCES art(code, objart);
ALTER TABLE "rel02_p" ADD CONSTRAINT art_fk FOREIGN KEY (art, objart) REFERENCES art(code, objart);


-- Attribute: vegetationsmerkmal
CREATE TABLE vegetationsmerkmal (
                     code VARCHAR(4) PRIMARY KEY,
                     name_en TEXT,
                     name_de TEXT,
                     definition_de TEXT,
                     CONSTRAINT check_column_format CHECK (
                         code ~ '^[0-9]{4}$'
                         OR LENGTH(code) = 4
)
    );

INSERT INTO vegetationsmerkmal VALUES (1010, 'Sand', 'Ackerland', '''Ackerland'' ist eine Fläche für den Anbau von Feldfrüchten (z.B. Getreide, Hülsenfrüchte, Hackfrüchte) und Beerenfrüchten (z.B. Erdbeeren).');
INSERT INTO vegetationsmerkmal VALUES (1011, 'Sand', 'Streuobstacker', '''Streuobstacker'' beschreibt den Bewuchs einer Ackerfläche mit Obstbäumen.');
INSERT INTO vegetationsmerkmal VALUES (1012, 'Sand', 'Hopfen', '''Hopfen'' ist eine mit speziellen Vorrichtungen ausgestattete Agrarfläche für den Anbau von Hopfen.');
INSERT INTO vegetationsmerkmal VALUES (1013, 'Sand', 'Spargel', '''Spargel'' beschreibt den Bewuchs einer Agrarfläche mit Spargelgewächsen.');
INSERT INTO vegetationsmerkmal VALUES (1014, 'Sand', 'Hanf', '''Hanf'' beschreibt den Bewuchs einer Agrarfläche mit Nutzhanf.');
INSERT INTO vegetationsmerkmal VALUES (1020, 'Sand', 'Grünland', '''Grünland'' ist eine Grasfläche, die gemäht oder beweidet wird.');
INSERT INTO vegetationsmerkmal VALUES (1021, 'Sand', 'Streuobstwiese', '''Streuobstwiese'' beschreibt den Bewuchs einer Grünlandfläche mit Obstbäumen.');
INSERT INTO vegetationsmerkmal VALUES (1022, 'Sand', 'Salzweide', '''Salzweide'' ist eine vom Meer periodisch überflutete Weidefläche, in der eine Salzpflanzenvegetation gedeiht. Dieser Bereich bildet den natürlichen Übergang vom Meer zum Festland.');
INSERT INTO vegetationsmerkmal VALUES (1030, 'Sand', 'Gartenbauland', '''Gartenbauland'' ist eine Fläche, die dem gewerbsmäßigen Anbau von Gartengewächsen (Gemüse, Obst und Blumen) sowie für die Aufzucht von Kulturpflanzen dient.');
INSERT INTO vegetationsmerkmal VALUES (1031, 'Sand', 'Baumschule', '''Baumschule'' ist eine Fläche, auf der Holzgewächse aus Samen, Ablegern oder Stecklingen unter mehrmaligem Umpflanzen (Verschulen) gezogen werden.');
INSERT INTO vegetationsmerkmal VALUES (1040, 'Sand', 'Rebfläche', '''Rebfläche'' ist eine mit speziellen Vorrichtungen ausgestattete Agrarfläche, auf der Weinstöcke angepflanzt sind.');
INSERT INTO vegetationsmerkmal VALUES (1050, 'Sand', 'Obst- und Nussplantage', '''Obst- und Nussplantage'' ist eine Fläche, die vorwiegend dem Intensivanbau dient und mit Obst-, Nussbäumen oder -sträuchern bepflanzt ist. Im Unterschied zu Streuobst handelt es sich hierbei um gleichmäßige und dichter angelegte Monokulturen.');
INSERT INTO vegetationsmerkmal VALUES (1051, 'Sand', 'Obst- und Nussbaumplantage', '''Obst- und Nussbaumplantage'' ist eine landwirtschaftliche Fläche, die vorwiegend dem Intensivanbau dient und mit Obst- oder Nussbäumen bepflanzt ist.');
INSERT INTO vegetationsmerkmal VALUES (1052, 'Sand', 'Obst- und Nussstrauchplantage', '''Obst- und Nussstrauchplantage'' ist eine landwirtschaftliche Fläche, die vorwiegend dem Intensivanbau dient und mit Obst- oder Nusssträuchern bepflanzt ist.');
INSERT INTO vegetationsmerkmal VALUES (1060, 'Sand', 'Weihnachtsbaumkultur', '''Weihnachtsbaumkultur'' bezeichnet eine landwirtschaftliche Fläche, die vorrangig mit Weihnachtsbäumen bepflanzt ist.');
INSERT INTO vegetationsmerkmal VALUES (1100, 'Sand', 'Kurzumtriebsplantage', '''Kurzumtriebsplantagen'' sind Flächen, auf denen Baumarten mit dem Ziel baldiger Holzentnahme angepflanzt werden und deren Bestände eine Umtriebszeit von nicht länger als 20 Jahren haben.');
INSERT INTO vegetationsmerkmal VALUES (1200, 'Sand', 'Brachland', '''Brachland'' ist eine Fläche der Landwirtschaft, die seit längerem nicht mehr zu Produktionszwecken genutzt wird.');

ALTER TABLE "veg01_f" ADD CONSTRAINT veg_fk FOREIGN KEY (veg) REFERENCES vegetationsmerkmal(code);

-- Attribute: bewuchs
CREATE TABLE bewuchs (
                                    code VARCHAR(4) PRIMARY KEY,
                                    name_en TEXT,
                                    name_de TEXT,
                                    definition_de TEXT,
                                    CONSTRAINT check_column_format CHECK (
                                        code ~ '^[0-9]{4}$'
                                        OR LENGTH(code) = 4
)
    );

INSERT INTO bewuchs VALUES (1011, 'Sand', 'Nadelbaum', '''Nadelbaum'' beschreibt die Zugehörigkeit eines einzeln stehenden Baumes zur Gruppe der Nadelhölzer.');
INSERT INTO bewuchs VALUES (1012, 'Sand', 'Laubbaum', '''Laubbaum'' beschreibt die Zugehörigkeit eines einzeln stehenden Baumes zur Gruppe der Laubhölzer.');
INSERT INTO bewuchs VALUES (1020, 'Sand', 'Baumbestand', '''Baumbestand'' beschreibt den Bewuchs einer Vegetationsfläche mit Bäumen.');
INSERT INTO bewuchs VALUES (1021, 'Sand', 'Baumbestand, Laubholz', '''Baumbestand, Laubholz'' beschreibt den Bewuchs einer Vegetationsfläche mit Laubbäumen.');
INSERT INTO bewuchs VALUES (1022, 'Sand', 'Baumbestand, Nadelholz', '''Baumbestand, Nadelholz'' beschreibt den Bewuchs einer Vegetationsfläche mit Nadelbäumen.');
INSERT INTO bewuchs VALUES (1023, 'Sand', 'Baumbestand, Laub- und Nadelholz', '''Baumbestand, Laub- und Nadelholz'' beschreibt den Bewuchs einer Vegetationsfläche mit Laub- und Nadelbäumen.');
INSERT INTO bewuchs VALUES (1100, 'Sand', 'Hecke', '''Hecke'' besteht aus einer Reihe dicht beieinander stehender, meist wildwachsender Sträucher.');
INSERT INTO bewuchs VALUES (1101, 'Sand', 'Heckenkante, rechts', '');
INSERT INTO bewuchs VALUES (1102, 'Sand', 'Heckenkante, links', '');
INSERT INTO bewuchs VALUES (1103, 'Sand', 'Heckenmitte', '');
INSERT INTO bewuchs VALUES (1210, 'Sand', 'Baumreihe, Laubholz', '''Laubholz'' beschreibt die Zugehörigkeit einer Baumreihe zur Gruppe der Laubhölzer.');
INSERT INTO bewuchs VALUES (1220, 'Sand', 'Baumreihe, Nadelholz', '''Nadelholz'' beschreibt die Zugehörigkeit einer Baumreihe zur Gruppe der Nadelhölzer.');
INSERT INTO bewuchs VALUES (1230, 'Sand', 'Baumreihe, Laub- und Nadelholz', '''Laub- und Nadelholz'' beschreibt den Bewuchs einer Baumreihe mit Laub- und Nadelbäumen.');
INSERT INTO bewuchs VALUES (1250, 'Sand', 'Gehölz', '''Gehölz'' ist eine Fläche, die mit einzelnen Bäumen, Baumgruppen, Büschen, Hecken und Sträuchern bestockt ist.');
INSERT INTO bewuchs VALUES (1260, 'Sand', 'Gebüsch', '''Gebüsch'' beschreibt den Bewuchs einer Vegetationsfläche mit Holzpflanzen, deren Sprossen sich nahe der Bodenoberfläche verzweigen.');
INSERT INTO bewuchs VALUES (1300, 'Sand', 'Schneise', '''Schneise'' ist eine künstlich angelegte Waldeinteilungslinie zur dauerhaften Begrenzung forstlicher Wirtschaftsflächen (räumliche Ordnung), die in der Regel geradlinig verläuft.');
INSERT INTO bewuchs VALUES (1400, 'Sand', 'Röhricht, Schilf', '''Röhricht, Schilf'' beschreibt den Bewuchs einer Vegetations- oder Wasserfläche mit Schilfrohr- und schilfrohrähnlichen Pflanzen.');
INSERT INTO bewuchs VALUES (1500, 'Sand', 'Gras', '''Gras'' beschreibt den Bewuchs einer Vegetationsfläche mit schlanken, krautigen einkeimblättrigen Blütenpflanzen.');
INSERT INTO bewuchs VALUES (1510, 'Sand', 'Rain', '');
INSERT INTO bewuchs VALUES (1600, 'Sand', 'Zierfläche', '');
INSERT INTO bewuchs VALUES (1700, 'Sand', 'Korbweide', '');
INSERT INTO bewuchs VALUES (1800, 'Sand', 'Reet', '''Reet'' bezeichnet eine ständig oder zeitweise unter Wasser stehende und mit Reet bewachsene Fläche.');
INSERT INTO bewuchs VALUES (1900, 'Sand', 'Streuobst', '''Streuobst'' beschreibt den Bewuchs einer Fläche mit Obstbäumen.');

ALTER TABLE "veg04_f" ADD CONSTRAINT bws_fk FOREIGN KEY (bws) REFERENCES bewuchs(code);


-- Attribute: schifffahrtskategorie
CREATE TABLE schifffahrtskategorie (
                         code VARCHAR(4) PRIMARY KEY,
                         name_en TEXT,
                         name_de TEXT,
                         definition_de TEXT,
                         CONSTRAINT check_column_format CHECK (
                             code ~ '^[0-9]{4}$'
                             OR LENGTH(code) = 4
)
    );
INSERT INTO schifffahrtskategorie VALUES (1000, 'Sand', 'Binnenwasserstraße', '''Binnenwasserstraße'' ist ein oberirdisches Gewässer oder Küstengewässer, das gesetzlich für den Personen- und/oder Güterverkehr mit Schiffen bestimmt ist. Binnengewässer im Küstengebiet sind gegen das Küstengewässer gesetzlich abgegrenzt. Die ''Binnenwasserstraße'' ist ein Gewässer 1. Ordnung.');
INSERT INTO schifffahrtskategorie VALUES (2000, 'Sand', 'Seewasserstraße', '''Seewasserstraße'' ist ein als Wasserstraße gesetzlich festgelegter Teil eines Küstengewässers. Die ''Seewasserstraße'' ist ein Gewässer 1. Ordnung.');
INSERT INTO schifffahrtskategorie VALUES (3000, 'Sand', 'Landesgewässer mit Verkehrsordnung', '''Landesgewässer mit Verkehrsordnung'' ist eine Wasserstraße, die keine Binnenwasserstraße ist. Die Schiffbarkeit wird durch eine Landesverkehrsordnung geregelt. Das ''Landesgewässer mit Verkehrsordnung'' ist ein Gewässer 1. Ordnung.');

ALTER TABLE "gew01_f" ADD CONSTRAINT sfk_fk FOREIGN KEY (sfk) REFERENCES schifffahrtskategorie(code);
ALTER TABLE "gew01_l" ADD CONSTRAINT sfk_fk FOREIGN KEY (sfk) REFERENCES schifffahrtskategorie(code);
ALTER TABLE "gew03_l" ADD CONSTRAINT sfk_fk FOREIGN KEY (sfk) REFERENCES schifffahrtskategorie(code);


-- Attribute:  artdergewaesserstationierungsachse
CREATE TABLE  artdergewaesserstationierungsachse (
                                       code VARCHAR(4) PRIMARY KEY,
                                       name_en TEXT,
                                       name_de TEXT,
                                       definition_de TEXT,
                                       CONSTRAINT check_column_format CHECK (
                                           code ~ '^[0-9]{4}$'
                                           OR LENGTH(code) = 4
)
    );
INSERT INTO artdergewaesserstationierungsachse VALUES (1000, 'Sand', 'Gewässerstationierungsachse der WSV', '''Gewässerstationierungsachse der WSV'' ist eine Gewässerachse, deren Geometrie unverändert aus den Unterlagen der Wasser- und Schifffahrtsverwaltung übernommen wurde.');
INSERT INTO artdergewaesserstationierungsachse VALUES (2000, 'Sand', 'Genäherte Mittellinie in Gewässern', '''Genäherte Mittellinie in Gewässern'' ist eine Gewässerachse, die den Spezifikationen der Richtlinie der ''Gebiets- und Gewässerverschlüsselung'' der Länderarbeitsgemeinschaft Wasser (LAWA) entspricht.');
INSERT INTO artdergewaesserstationierungsachse VALUES (3001, 'Sand', 'Fiktive Verbindung in Fließgewässern', '''Fiktive Verbindung in Fließgewässern'' ist eine Gewässerachse, die ein einmündendes Gewässer mit der Gewässerachse des aufnehmenden Fließgewässers verbindet.');
INSERT INTO artdergewaesserstationierungsachse VALUES (3002, 'Sand', 'Fiktive Verbindung in Seen und Teichen', '''Fiktive Verbindung in Seen und Teichen'' ist eine hydrologisch sinnvolle Verbindungslinie in stehenden Gewässern, die für den Aufbau eines geschlossenen topologischen Gewässernetzes benötigt wird.');

ALTER TABLE "gew03_l" ADD CONSTRAINT aga_fk FOREIGN KEY (aga) REFERENCES artdergewaesserstationierungsachse(code);

-- Attribute:  landschaftstyp
CREATE TABLE  landschaftstyp (
                                                     code VARCHAR(4) PRIMARY KEY,
                                                     name_en TEXT,
                                                     name_de TEXT,
                                                     definition_de TEXT,
                                                     CONSTRAINT check_column_format CHECK (
                                                         code ~ '^[0-9]{4}$'
                                                         OR LENGTH(code) = 4
)
    );
INSERT INTO landschaftstyp VALUES (1100, 'Sand', 'Gebirge, Bergland, Hügelland', '''Gebirge, Bergland, Hügelland'' bezeichnet eine zusammenhängende größere Erhebung der Erdoberfläche. Es besteht aus einzelnen Bergen und Hochflächen, die durch Täler und Senken gegliedert sind.');
INSERT INTO landschaftstyp VALUES (1200, 'Sand', 'Berg, Berge', '''Berg, Berge'' bezeichnet eine über die Umgebung deutlich herausragende Geländeerhebung, einzeln oder als Teil eines Gebirges.');
INSERT INTO landschaftstyp VALUES (1300, 'Sand', 'Becken, Senke', '''Becken, Senke'' bezeichnet ein gegenüber der Umgebung tiefer liegendes Land.');
INSERT INTO landschaftstyp VALUES (1400, 'Sand', 'Tal, Niederung', '''Tal, Niederung'' bezeichnet im Bergland einen langgestreckten oder gewundenen, unterschiedlich tiefen und breiten Einschnitt im Gelände mit gleichsinnig gerichtetem Gefälle einschließlich des dazu gehörigen Talraumes, im Flachland eine offene Hohlform. Ferner zählen hierzu auch (talähnliche) Talungen und glaziale Rinnen, die beide kein gleichsinniges Gefälle aufweisen.');
INSERT INTO landschaftstyp VALUES (1500, 'Sand', '(Tief-) Ebene, Flachland', '''(Tief-) Ebene, Flachland'' ist ein Teil der Erdoberfläche mit geringen Höhenunterschieden in einer Höhenlage bis 200- 300 m über NHN.');
INSERT INTO landschaftstyp VALUES (1600, 'Sand', 'Plateau, Hochfläche', '''Plateau, Hochfläche'', bezeichnet einen Teil der Erdoberfläche mit fehlenden oder kaum wahrnehmbaren Höhenunterschieden in einer Höhenlage ab etwa 200-300 m über NHN.');
INSERT INTO landschaftstyp VALUES (1700, 'Sand', 'Mündungsgebiet', '''Mündungsgebiet'' bezeichnet die typische, durch Ablagerung von Schwebestoffen entstandene Landschaft im Bereich der Mündung eines fließenden Gewässers in ein anderes Binnengewässer oder in ein Meer.');
INSERT INTO landschaftstyp VALUES (1800, 'Sand', 'Dünenlandschaft', '''Dünenlandschaft'' ist eine, vom Wind gebildete, durch Sandanhäufungen geprägte Landschaft.');
INSERT INTO landschaftstyp VALUES (1900, 'Sand', 'Wald-, Heidelandschaft', '''Wald-, Heidelandschaft'' ist eine größere zusammenhängende, mit Bäumen bestandene Fläche (Wald) einschließlich darin befindlicher Lichtungen. Hierzu gehören viele ehemalige Heiden, die heute vorwiegend ökonomisch genutzte monokulturartige Forste mit meist Fichten- oder Kiefernbeständen bilden.');
INSERT INTO landschaftstyp VALUES (2000, 'Sand', 'Inselgruppe', '''Inselgruppe'' ist eine Gruppe mehrerer nahe beieinander liegender Inseln geologisch gleicher Entstehung.');
INSERT INTO landschaftstyp VALUES (2100, 'Sand', 'Seenlandschaft', '''Seenlandschaft'' ist eine durch zahlreiche, nahe beieinander liegende Binnenseen geprägte Landschaft.');
INSERT INTO landschaftstyp VALUES (2200, 'Sand', 'Siedlungs-, Wirtschaftslandschaft', '''Siedlungs-, Wirtschaftslandschaft'' ist eine durch Siedlungsverdichtung oder spezielle Wirtschaftsorientierung geprägte Landschaft.');
INSERT INTO landschaftstyp VALUES (2300, 'Sand', 'Moorlandschaft', '''Moorlandschaft'' ist eine durch heutige und ehemalige Moore gekennzeichnete Landschaft.');
INSERT INTO landschaftstyp VALUES (2400, 'Sand', 'Heidelandschaft', '''Heidelandschaft'' ist eine waldfreie Landschaft der unteren Höhenstufen, die von einer mehr oder weniger lockeren Zwergstrauchformation geprägt wird.');
INSERT INTO landschaftstyp VALUES (2500, 'Sand', 'Küstenlandschaft', '''Küstenlandschaft'' enthält jene auf dem Festland gelegenen Gebiete, die dem Meer abgerungen worden sind (Polder, Marschen), deren Entstehung dem Meer zu verdanken ist (Nehrungen, Haken) oder deren Küste durch das Meer geformt wird (Steilküste, Strände, Halbinseln).');


ALTER TABLE "geb02_f" ADD CONSTRAINT ltp_fk FOREIGN KEY (ltp) REFERENCES landschaftstyp(code);


-- Attribute:  artderfestlegung
CREATE TABLE  artderfestlegung (
                                 code VARCHAR(4) PRIMARY KEY,
                                 name_en TEXT,
                                 name_de TEXT,
                                 definition_de TEXT,
                                 CONSTRAINT check_column_format CHECK (
                                     code ~ '^[0-9]{4}$'
                                     OR LENGTH(code) = 4
)
    );

INSERT INTO artderfestlegung VALUES (1610, 'Sand', 'Schutzfläche nach Europarecht', '');
INSERT INTO artderfestlegung VALUES (1611, 'Sand', 'Flora-Fauna-Habitat-Gebiet', '''Flora-Fauna-Habitat-Gebiet'' ist ein Schutzgebiet von gemeinschaftlicher Bedeutung im Sinne der Richtlinie 92/43/EWG des Rates der Europäischen Wirtschaftsgemeinschaft zur Erhaltung der natürlichen Lebensräume sowie der wildlebenden Pflanzen und Tiere.');
INSERT INTO artderfestlegung VALUES (1612, 'Sand', 'Vogelschutzgebiet', '''Vogelschutzgebiet'' ist ein besonderes Schutzgebiet (Special Protected Area, SPA) im Sinne Artikel 4 Abs. 1 der Richtlinie 79/409/EWG des Rates der Europäischen Wirtschaftsgemeinschaft über die Erhaltung der wildlebenden Vogelarten (Vogelschutzrichtlinie).');
INSERT INTO artderfestlegung VALUES (1615, 'Sand', 'Nationales Naturmonument', '''Nationales Naturmonument'' ist ein rechtsverbindlich festgesetztes Gebiet von herausragender Bedeutung (Bundesnaturschutzgesetz §24 Abs.4).');
INSERT INTO artderfestlegung VALUES (1620, 'Sand', 'Schutzflächen nach Landesnaturschutzgesetz', '');
INSERT INTO artderfestlegung VALUES (1621, 'Sand', 'Naturschutzgebiet', '''Naturschutzgebiet'' ist ein rechtsverbindlich festgesetztes Gebiet, in dem ein besonderer Schutz von Natur und Landschaft in ihrer Ganzheit oder in einzelnen Teilen zur Erhaltung von Lebensgemeinschaften oder Biotopen bestimmter wildlebender Tier- und Pflanzenarten, aus wissenschaftlichen, naturgeschichtlichen oder landeskundlichen Gründen oder wegen ihrer Seltenheit, besonderen Eigenart oder hervorragenden Schönheit erforderlich ist.');
INSERT INTO artderfestlegung VALUES (1622, 'Sand', 'Geschützter Landschaftsbestandteil', '''Geschützter Landschaftsbestandteil'' ist ein rechtsverbindlich festgesetzter Teil von Natur und Landschaft, dessen besonderer Schutz zur Sicherstellung der Leistungsfähigkeit des Naturhaushalts, zur Belebung, Gliederung oder Pflege des Orts- und Landschaftsbildes oder zur Abwehr schädlicher Einwirkungen erforderlich ist.');
INSERT INTO artderfestlegung VALUES (1623, 'Sand', 'Landschaftsschutzgebiet', '''Landschaftsschutzgebiet'' ist ein rechtsverbindlich festgesetztes Gebiet, in dem ein besonderer Schutz von Natur und Landschaft zur Erhaltung oder Wiederherstellung der Leistungsfähigkeit des Naturhaushalts oder der Nutzungsfähigkeit der Naturgüter, wegen der Vielfalt, Eigenart oder Schönheit des Landschaftsbildes oder wegen der besonderen Bedeutung für die Erholung erforderlich ist.');
INSERT INTO artderfestlegung VALUES (1624, 'Sand', 'Naturpark', '''Naturpark'' ist ein einheitlich zu entwickelndes und zu pflegendes Gebiet, das großräumig ist, überwiegend Landschaftsschutzgebiet oder Naturschutzgebiet ist, sich wegen seiner landschaftlichen Voraussetzungen für die Erholung besonders eignet und nach den Grundsätzen und Zielen der Raumordnung und der Landesplanung für die Erholung oder den Fremdenverkehr vorgesehen ist.');
INSERT INTO artderfestlegung VALUES (1630, 'Sand', 'RainBundesbodenschutzgesetz', '');
INSERT INTO artderfestlegung VALUES (1631, 'Sand', 'Verdachtsfläche auf schädliche Bodenveränderung', '');
INSERT INTO artderfestlegung VALUES (1632, 'Sand', 'Schädliche Bodenveränderung', '');
INSERT INTO artderfestlegung VALUES (1633, 'Sand', 'Altlastenverdächtige Fläche', '');
INSERT INTO artderfestlegung VALUES (1634, 'Sand', 'Altlast', '');
INSERT INTO artderfestlegung VALUES (1635, 'Sand', 'Gesicherte Altlast', '');
INSERT INTO artderfestlegung VALUES (1636, 'Sand', 'Gesicherte schädliche Bodenveränderung', '');
INSERT INTO artderfestlegung VALUES (1640, 'Sand', 'Bundesimmisionsschutzgesetz', '');
INSERT INTO artderfestlegung VALUES (1641, 'Sand', 'Belastungsgebiet', '');
INSERT INTO artderfestlegung VALUES (1642, 'Sand', 'Schutzbedürftiges Gebiet', '');
INSERT INTO artderfestlegung VALUES (1643, 'Sand', 'Gefährdetes Gebiet', '');
INSERT INTO artderfestlegung VALUES (1650, 'Sand', 'Naturschutzgesetz', '');
INSERT INTO artderfestlegung VALUES (1651, 'Sand', 'Besonders geschütztes Biotop', '');
INSERT INTO artderfestlegung VALUES (1652, 'Sand', 'Besonders geschütztes Feuchtgrünland', '');
INSERT INTO artderfestlegung VALUES (1653, 'Sand', 'Naturdenkmal', '''Naturdenkmal'' ist eine rechtsverbindlich festgesetzte Einzelschöpfung der Natur, deren besonderer Schutz erforderlich ist (z.B. Baum).');
INSERT INTO artderfestlegung VALUES (1654, 'Sand', 'Einstweilige Sicherstellung, Veränderungssperre', '');
INSERT INTO artderfestlegung VALUES (1655, 'Sand', 'Vorkaufsrecht', '');
INSERT INTO artderfestlegung VALUES (1656, 'Sand', 'Ausgleichs- oder Kompensationsfläche', '');
INSERT INTO artderfestlegung VALUES (1660, 'Sand', 'Bodenschutzgesetz', '');
INSERT INTO artderfestlegung VALUES (1661, 'Sand', 'Dauerbeobachtungsflächen', '');
INSERT INTO artderfestlegung VALUES (1662, 'Sand', 'Bodenschutzgebiet', '');
INSERT INTO artderfestlegung VALUES (1644, 'Sand', 'Abstandszone, Störfallbetrieb', '');
INSERT INTO artderfestlegung VALUES (4100, 'Sand', 'Luftverkehrsgesetz', '');
INSERT INTO artderfestlegung VALUES (4110, 'Sand', 'Bauschutzbereich', '');
INSERT INTO artderfestlegung VALUES (4120, 'Sand', 'Beschränkter Bauschutzbereich', '');
INSERT INTO artderfestlegung VALUES (4200, 'Sand', 'Bundeskleingartengesetz', '');
INSERT INTO artderfestlegung VALUES (4210, 'Sand', 'Dauerkleingarten', '');
INSERT INTO artderfestlegung VALUES (4300, 'Sand', 'Berggesetz', '');
INSERT INTO artderfestlegung VALUES (4301, 'Sand', 'Bodenbewegungsgebiet', '''Bodenbewegungsgebiet'' ist ein Gebiet, in dem sich die oberen Erdschichten auf Grund verschiedener Einflüsse (z.B. geologische Kräfte, Bergbau) lage- oder höhenmäßig verändern.');
INSERT INTO artderfestlegung VALUES (4302, 'Sand', 'Bruchfeld', '''Bruchfeld'' ist ein durch Bergbau unterhöhltes Gebiet, das teilweise bereits eingebrochen ist oder sich in Absenkung befindet.');
INSERT INTO artderfestlegung VALUES (4310, 'Sand', 'Baubeschränkung', '');
INSERT INTO artderfestlegung VALUES (4400, 'Sand', 'Reichsheimstättengesetz', '');
INSERT INTO artderfestlegung VALUES (4410, 'Sand', 'Reichsheimstätte', '');
INSERT INTO artderfestlegung VALUES (4500, 'Sand', 'Schutzbereichsgesetz', '');
INSERT INTO artderfestlegung VALUES (4510, 'Sand', 'Schutzbereich', '');
INSERT INTO artderfestlegung VALUES (4600, 'Sand', 'Eisenbahnneuordnungsgesetz', '');
INSERT INTO artderfestlegung VALUES (4610, 'Sand', 'Übergabebescheidverfahren', '');
INSERT INTO artderfestlegung VALUES (4710, 'Sand', 'Baubeschränkungen durch Richtfunkverbindungen', '');
INSERT INTO artderfestlegung VALUES (4720, 'Sand', 'Truppenübungsplatz, Standortübungsplatz', '''Truppenübungsplatz, Standortübungsplatz'' ist ein Gelände zur militärischen Ausbildung.');
INSERT INTO artderfestlegung VALUES (4730, 'Sand', 'Militärbrache', '''Militärbrache'' ist eine ehemals militärisch genutzte Fläche, die aktuell nicht mehr militärisch genutzt wird.');
INSERT INTO artderfestlegung VALUES (4800, 'Sand', 'Vermessungs- und Katasterrecht', '');
INSERT INTO artderfestlegung VALUES (4810, 'Sand', 'Schutzfläche Festpunkt', '');
INSERT INTO artderfestlegung VALUES (4811, 'Sand', 'Schutzfläche Festpunkt, 1 m Radius', '');
INSERT INTO artderfestlegung VALUES (4812, 'Sand', 'Schutzfläche Festpunkt, 2 m Radius', '')
INSERT INTO artderfestlegung VALUES (4813, 'Sand', 'Schutzfläche Festpunkt, 5 m Radius', '');
INSERT INTO artderfestlegung VALUES (4814, 'Sand', 'Schutzfläche Festpunkt, 10 m Radius', '')
INSERT INTO artderfestlegung VALUES (4815, 'Sand', 'Schutzfläche Festpunkt, 30 m Radius', '');
INSERT INTO artderfestlegung VALUES (4820, 'Sand', 'Marksteinschutzfläche', '');
INSERT INTO artderfestlegung VALUES (4830, 'Sand', 'Liegenschaftskatastererneuerung', '');
INSERT INTO artderfestlegung VALUES (4900, 'Sand', 'Fischereirecht', '');
INSERT INTO artderfestlegung VALUES (5100, 'Sand', 'Jagdkataster', '');
INSERT INTO artderfestlegung VALUES (5200, 'Sand', 'Landesgrundbesitzkataster', '');
INSERT INTO artderfestlegung VALUES (5300, 'Sand', 'Bombenblindgängerverdacht', '');
INSERT INTO artderfestlegung VALUES (5400, 'Sand', 'Rieselfeld', '''Rieselfeld'' ist eine Fläche, auf der organisch verunreinigtes Wasser zum Zwecke der biologischen Reinigung verrieselt wird.');
INSERT INTO artderfestlegung VALUES (5500, 'Sand', 'Sicherungsstreifen', '');
INSERT INTO artderfestlegung VALUES (5600, 'Sand', 'Grenzbereinigung', '');
INSERT INTO artderfestlegung VALUES (5700, 'Sand', 'Hochwasserdeich', '''Hochwasserdeich'' ist die Eigenschaft (Widmung) eines Deiches, die durch die obere Deichbehörde festgelegt wird.');
INSERT INTO artderfestlegung VALUES (5710, 'Sand', 'Hauptdeich, 1. Deichlinie', '''Hauptdeich, 1. Deichlinie'' ist die Eigenschaft (Widmung) eines Deiches, die durch die obere Deichbehörde festgelegt wird.');
INSERT INTO artderfestlegung VALUES (5720, 'Sand', '2. Deichlinie', '''2. Deichlinie'' ist die Eigenschaft (Widmung) eines Deiches, die durch die obere Deichbehörde festgelegt wird.');
INSERT INTO artderfestlegung VALUES (6000, 'Sand', 'Beregnungsverband', '');
INSERT INTO artderfestlegung VALUES (7000, 'Sand', 'Weinlage', '');
INSERT INTO artderfestlegung VALUES (7100, 'Sand', 'Weinbausteillage', '');
INSERT INTO artderfestlegung VALUES (7200, 'Sand', 'Weinbergsrolle', '');
INSERT INTO artderfestlegung VALUES (7300, 'Sand', 'Weinbausteilstlage', '');
INSERT INTO artderfestlegung VALUES (8000, 'Sand', 'Benachteiligtes landwirtschaftliches Gebiet', '');
INSERT INTO artderfestlegung VALUES (9100, 'Sand', 'Mitverwendung Hochwasserschutz, Oberirdische Anlagen', '');
INSERT INTO artderfestlegung VALUES (9200, 'Sand', 'Mitverwendung Hochwasserschutz, Unterirdische Anlagen', '');
INSERT INTO artderfestlegung VALUES (9300, 'Sand', 'Hafennutzungsgebiet', '');
INSERT INTO artderfestlegung VALUES (9400, 'Sand', 'Hafenerweiterungsgebiet', '');
INSERT INTO artderfestlegung VALUES (9450, 'Sand', 'Hafenbecken', '''Hafenbecken'' ist ein rechtlich definierter Teil eines Gewässers, in dem Schiffe be- und entladen werden');
INSERT INTO artderfestlegung VALUES (9500, 'Sand', 'Bohrung verfüllt', '');
INSERT INTO artderfestlegung VALUES (9600, 'Sand', 'Zollgrenze', '');
INSERT INTO artderfestlegung VALUES (9700, 'Sand', 'Belastung nach §7 Abs. 2 GBO', '');
INSERT INTO artderfestlegung VALUES (9999, 'Sand', 'Sonstiges', '''Sonstiges'' bedeutet, dass ''Art der Festlegung'' bekannt, aber nicht in der Attributwertliste aufgeführt ist.');
INSERT INTO artderfestlegung VALUES (4100, 'Sand', 'Luftverkehrsgesetz', '');

ALTER TABLE "geb03_f" ADD CONSTRAINT adf_fk FOREIGN KEY (adf) REFERENCES artderfestlegung(code);

-- Attribute:  administrativefunktion
CREATE TABLE  administrativefunktion (
                                   code VARCHAR(4) PRIMARY KEY,
                                   name_en TEXT,
                                   name_de TEXT,
                                   definition_de TEXT,
                                   CONSTRAINT check_column_format CHECK (
                                       code ~ '^[0-9]{4}$'
                                       OR LENGTH(code) = 4
)
    );

INSERT INTO administrativefunktion VALUES (1001, 'Sand', 'Bundesrepublik', '''Bundesrepublik'' ist die Bezeichnung Deutschlands und ist aus der Gesamtheit der deutschen Länder (Gliedstaaten) gebildet.');
INSERT INTO administrativefunktion VALUES (2001, 'Sand', 'Land', '''Land'' ist ein teilsouveräner Gliedstaat der Bundesrepublik Deutschland.');
INSERT INTO administrativefunktion VALUES (2002, 'Sand', 'Freistaat', '''Freistaat'' ist ein teilsouveräner Gliedstaat der Bundesrepublik Deutschland (historisch gewachsene Bezeichnung für Land).');
INSERT INTO administrativefunktion VALUES (2003, 'Sand', 'Freie und Hansestadt', '''Freie und Hansestadt'' ist eine historisch gewachsene Bezeichnung.');
INSERT INTO administrativefunktion VALUES (3001, 'Sand', 'Regierungsbezirk', '''Regierungsbezirk'' ist ein Verwaltungsbezirk innerhalb eines Landes, welcher mehrere Stadt- und Landkreise umfasst.');
INSERT INTO administrativefunktion VALUES (3002, 'Sand', 'Freie Hansestadt', '''Freie Hansestadt'' ist eine historisch gewachsene Bezeichnung.');
INSERT INTO administrativefunktion VALUES (3003, 'Sand', 'Bezirk', '''Bezirk'' ist ein abgegrenztes Gebiet einer Stadt.');
INSERT INTO administrativefunktion VALUES (3004, 'Sand', 'Stadt (Bremerhaven)', '''Stadt (Bremerhaven)'' ist die Bezeichnung der kreisfreien Stadt Bremerhaven.');
INSERT INTO administrativefunktion VALUES (3005, 'Sand', 'Regierungsvertretung', '''Regierungsvertretung'' ist eine Bezeichung von Referaten des Niedersächsischen Ministeriums für Inneres und Sport.');
INSERT INTO administrativefunktion VALUES (4001, 'Sand', 'Kreis', '''Kreis'' ist eine mehrere Gemeinden bzw. Städte umfassende kommunale Verwaltungseinheit.');
INSERT INTO administrativefunktion VALUES (4002, 'Sand', 'Landkreis', '''Landkreis'' ist eine mehrere Gemeinden bzw. Städte umfassende kommunale Verwaltungseinheit.');
INSERT INTO administrativefunktion VALUES (4003, 'Sand', 'Kreisfreie Stadt', '''Kreisfreie Stadt'' ist eine kommunale Verwaltungseinheit, die keinem ''Kreis'' oder ''Landkreis'' angehört.');
INSERT INTO administrativefunktion VALUES (4007, 'Sand', 'Ursprünglich gemeindefreies Gebiet', '');
INSERT INTO administrativefunktion VALUES (4008, 'Sand', 'Ortsteil', '''Ortsteil'' ist ein räumlich abgegrenzter Bereich einer Gemeinde.');
INSERT INTO administrativefunktion VALUES (4009, 'Sand', 'Region', '');
INSERT INTO administrativefunktion VALUES (5001, 'Sand', 'Verbandsgemeinde', '''Verbandsgemeinde'' ist eine kommunale Verwaltungskooperation zwischen Gemeinden.');
INSERT INTO administrativefunktion VALUES (5002, 'Sand', 'Verbandsfreie Gemeinde', '''Verbandsfreie Gemeinde'' ist eine kreisangehörige Gebietskörperschaft, die keiner ''Verbandsgemeinde'' angehört.');
INSERT INTO administrativefunktion VALUES (5003, 'Sand', 'Verwaltungsverband', '''Verwaltungsverband'' ist eine kommunale Verwaltungskooperation zwischen Gemeinden.');
INSERT INTO administrativefunktion VALUES (5004, 'Sand', 'Große kreisangehörige Stadt', '''Große kreisangehörige Stadt'' ist eine kreisangehörige Stadt, die bestimmte Verwaltungsfunktionen vom Landkreis/Kreis übernimmt. Hinweis: Unterscheidung zu 6013 ''Große kreisangehoerige Stadt'' aufgrund länderspezifischer Anforderungen.');
INSERT INTO administrativefunktion VALUES (5006, 'Sand', 'Verwaltungsgemeinschaft', '''Verwaltungsgemeinschaft'' ist eine kommunale Verwaltungskooperation zwischen Gemeinden.');
INSERT INTO administrativefunktion VALUES (5007, 'Sand', 'Amt', '''Amt'' ist eine kommunale Verwaltungskooperation zwischen Gemeinden.');
INSERT INTO administrativefunktion VALUES (5008, 'Sand', 'Samtgemeinde', '''Samtgemeinde'' ist eine kommunale Verwaltungskooperation zwischen Gemeinden.');
INSERT INTO administrativefunktion VALUES (5009, 'Sand', 'Gemeindeverwaltungsverband', '''Gemeindeverwaltungsverband'' ist eine kommunale Verwaltungskooperation zwischen Gemeinden.');
INSERT INTO administrativefunktion VALUES (5012, 'Sand', 'Gemeinde, die sich einer erfüllenden Gemeinde bedient', '''Gemeinde, die sich einer erfüllenden Gemeinde bedient'' ist eine Gemeinde, die Verwaltungsfunktionen von einer anderen Gemeinde erfüllen lässt.');
INSERT INTO administrativefunktion VALUES (5013, 'Sand', 'Erfüllende Gemeinde', '''Erfüllende Gemeinde'' ist eine Gemeinde, die Verwaltungsfunktionen für andere Gemeinden erfüllt.');
INSERT INTO administrativefunktion VALUES (5014, 'Sand', 'Einheitsgemeinde', '''Einheitsgemeinde'' ist die Bezeichnung für eine bestimmte länderspezifische Form eines kommunalen Gemeindetyps in Deutschland.');
INSERT INTO administrativefunktion VALUES (6001, 'Sand', 'Gemeinde', '''Gemeinde'' ist unterste selbständige Verwaltungseinheit.');
INSERT INTO administrativefunktion VALUES (6002, 'Sand', 'Ortsgemeinde', '''Ortsgemeinde'' ist eine Gemeinde, die einer Verbandsgemeinde angehört.');
INSERT INTO administrativefunktion VALUES (6003, 'Sand', 'Stadt', '''Stadt'' ist eine Gemeinde, die den Titel Stadt trägt.');
INSERT INTO administrativefunktion VALUES (6004, 'Sand', 'Kreisangehörige Stadt', '''Kreisangehörige Stadt'' ist eine Stadt, die einem Landkreis/Kreis angehört.');
INSERT INTO administrativefunktion VALUES (6005, 'Sand', 'Große Kreisstadt', '''Große Kreisstadt'' ist eine kreisangehörige Stadt, die bestimmte Verwaltungsfunktionen vom Landkreis/Kreis übernimmt.');
INSERT INTO administrativefunktion VALUES (6006, 'Sand', 'Amtsangehörige Stadt', '''Amtsangehörige Stadt'' ist eine kreisangehörige Stadt, die einem Amt angehört.');
INSERT INTO administrativefunktion VALUES (6007, 'Sand', 'Amtsangehörige Landgemeinde', '''Amtsangehörige Landgemeinde‘ ist eine kreisangehörige Gemeinde, die einem Amt angehört.');
INSERT INTO administrativefunktion VALUES (6008, 'Sand', 'Amtsangehörige Gemeinde', '''Amtsangehörige Gemeinde'' ist eine kreisangehörige Gemeinde, die einem Amt angehört.');
INSERT INTO administrativefunktion VALUES (6009, 'Sand', 'Kreisangehörige Gemeinde', '''Kreisangehörige Gemeinde'' ist eine Gemeinde, die einem Landkreis/Kreis angehört.');
INSERT INTO administrativefunktion VALUES (6010, 'Sand', 'Mitgliedsgemeinde einer Verwaltungsgemeinschaft', '''Mitgliedsgemeinde einer Verwaltungsgemeinschaft'' ist eine kreisangehörige Gemeinde bzw. Stadt, die einer Verwaltungsgemeinschaft angehört.');
INSERT INTO administrativefunktion VALUES (6011, 'Sand', 'Mitgliedsgemeinde', '''Mitgliedsgemeinde'' ist eine ''Gemeinde'', die Teil einer Verwaltungskooperation ist.');
INSERT INTO administrativefunktion VALUES (6012, 'Sand', 'Markt', '''Markt'' ist eine kreisangehörige Gemeinde, die den Titel Markt trägt.');
INSERT INTO administrativefunktion VALUES (6013, 'Sand', 'Große kreisangehoerige Stadt', '''Große kreisangehoerige Stadt'' ist eine kreisangehörige Stadt, die bestimmte Verwaltungsfunktionen vom Landkreis/Kreis übernimmt. Hinweis: Unterscheidung zu 5004 ''Große kreisangehörige Stadt'' aufgrund länderspezifischer Anforderungen.');
INSERT INTO administrativefunktion VALUES (6014, 'Sand', 'Kreisangehörige Gemeinde, die die Bezeichnung Stadt führt', '''Kreisangehörige Gemeinde, die die Bezeichnung Stadt führt'' ist eine Gemeinde, die den Titel Stadt führt und einem Landkreis/Kreis angehört.');
INSERT INTO administrativefunktion VALUES (6015, 'Sand', 'Gemeindefreies Gebiet', '''Gemeindefreies Gebiet'' ist ein Gebiet, das zu keiner Gemeinde gehört.');
INSERT INTO administrativefunktion VALUES (6016, 'Sand', 'Gemeindefreier Bezirk', '');
INSERT INTO administrativefunktion VALUES (6017, 'Sand', 'Landeshauptstadt', '');
INSERT INTO administrativefunktion VALUES (6018, 'Sand', 'Bergstadt', '');
INSERT INTO administrativefunktion VALUES (6019, 'Sand', 'Hansestadt', '');
INSERT INTO administrativefunktion VALUES (6020, 'Sand', 'Inselgemeinde', '');
INSERT INTO administrativefunktion VALUES (6021, 'Sand', 'Flecken', '');
INSERT INTO administrativefunktion VALUES (7001, 'Sand', 'Gemeindeteil', '''Gemeindeteil'' ist ein räumlich abgetrennter Bereich einer Gemeinde.');
INSERT INTO administrativefunktion VALUES (7003, 'Sand', 'Gemarkung', '''Gemarkung'' ist eine Flächeneinheit des Katasters.');
INSERT INTO administrativefunktion VALUES (7004, 'Sand', 'Stadtteil', '''Stadtteil'' ist ein räumlich abgetrennter Bereich einer Stadt.');
INSERT INTO administrativefunktion VALUES (7005, 'Sand', 'Stadtbezirk', '''Stadtbezirk'' ist ein abgegrenztes Gebiet einer Stadt.');
INSERT INTO administrativefunktion VALUES (7007, 'Sand', 'Ortsteil (Gemeinde)', '''Ortsteil'' ist ein räumlich abgetrennter Bereich einer Gemeinde.');
INSERT INTO administrativefunktion VALUES (8001, 'Sand', 'Kondominium', '''Kondominium'' ist ein Gebiet, welches unter der gemeinsamen Verwaltung mehrerer Staaten steht.');

ALTER TABLE "geb01_f" ADD CONSTRAINT adm_fk FOREIGN KEY (adm) REFERENCES administrativefunktion(code);


-- Attribute:  artdergebietsgrenze
CREATE TABLE  artdergebietsgrenze (
                                         code VARCHAR(4) PRIMARY KEY,
                                         name_en TEXT,
                                         name_de TEXT,
                                         definition_de TEXT,
                                         CONSTRAINT check_column_format CHECK (
                                             code ~ '^[0-9]{4}$'
                                             OR LENGTH(code) = 4
)
    );

INSERT INTO artdergebietsgrenze VALUES (6021, 'Sand', 'Grenze eines Staates', '''Grenze eines Staates'' ist eine politische Grenze zwischen Staaten zur Sicherung der territorialen Integrität und der exakten Definition des räumlichen Geltungsbereichs staatlicher Rechtsordnungen.');
INSERT INTO artdergebietsgrenze VALUES (6021, 'Sand', 'Grenze der Bundesrepublik Deutschland', '''Grenze der Bundesrepublik Deutschland'' begrenzt das Gebiet der Bundesrepublik Deutschland.');
INSERT INTO artdergebietsgrenze VALUES (6021, 'Sand', 'Grenze des Bundeslandes', '''Grenze des Bundeslandes'' begrenzt das Gebiet einer Verwaltungseinheit auf der Bundeslandebene.');
INSERT INTO artdergebietsgrenze VALUES (6021, 'Sand', 'Grenze des Regierungsbezirks', '''Grenze des Regierungsbezirks'' begrenzt das Gebiet einer Verwaltungseinheit auf der Regierungsbezirksebene.');
INSERT INTO artdergebietsgrenze VALUES (6021, 'Sand', 'Grenze des Kreises / Kreisfreien Stadt / Region', '''Grenze des Kreises / Kreisfreien Stadt / Region'' begrenzt das Gebiet einer Verwaltungseinheit auf der Kreisebene bzw. der kreisfreien Stadt.');
INSERT INTO artdergebietsgrenze VALUES (6021, 'Sand', 'Grenze der Verwaltungsgemeinschaft', '''Grenze der Verwaltungsgemeinschaft'' begrenzt das Gebiet einer Verwaltungseinheit auf der Verwaltungsgemeinschaftsebene.');
INSERT INTO artdergebietsgrenze VALUES (6021, 'Sand', 'Grenze der Gemeinde', '''Grenze der Gemeinde'' begrenzt ein kommunales Gebiet auf der Gemeindeebene.');
INSERT INTO artdergebietsgrenze VALUES (6021, 'Sand', 'Grenze des Gemeindeteils', '''Grenze des Gemeindeteils'' begrenzt das Gebiet einer Verwaltungseinheit auf der Gemeindeteilebene.');
INSERT INTO artdergebietsgrenze VALUES (6021, 'Sand', 'Grenze eines Kondominiums', '''Grenze eines Kondominiums'' begrenzt ein Gebiet, das unter gemeinsamer Verwaltung von zwei oder mehreren Staaten steht.');

ALTER TABLE "geb01_l" ADD CONSTRAINT agz_fk FOREIGN KEY (agz) REFERENCES artdergebietsgrenze(code);