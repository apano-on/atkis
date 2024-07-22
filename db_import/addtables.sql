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
CREATE TABLE widmung_traffic (
                                 code VARCHAR(4) PRIMARY KEY,
                                 name_en TEXT,
                                 name_de TEXT,
                                 definition_de TEXT,
                                 CONSTRAINT check_column_format CHECK (
                                     code ~ '^[0-9]{4}$'
                                     OR LENGTH(code) = 4
)
    );
INSERT INTO widmung_traffic VALUES (1301, 'Federal motorway', 'Bundesautobahn' , '''Bundesautobahn'' ist eine durch Verwaltungsakt zur Bundesautobahn gewidmete Bundesfernstraße.');
INSERT INTO widmung_traffic VALUES (1303, 'Federal road', 'Bundesstraße' , '''Bundesstraße'' ist eine durch Verwaltungsakt zur Bundesstraße gewidmete Bundesfernstraße.');
INSERT INTO widmung_traffic VALUES (1305, 'National road, state road', 'Landesstraße, Staatsstraße' , '''Landesstraße, Staatsstraße'' ist eine durch Verwaltungsakt zur Landesstraße bzw. Staatsstraße gewidmete Straße.');
INSERT INTO widmung_traffic VALUES (1306, 'District road', 'Kreisstraße' , '''Kreisstraße'' ist eine durch Verwaltungsakt zur Kreisstraße gewidmete Straße.');
INSERT INTO widmung_traffic VALUES (1307, 'Municipal road', 'Gemeindestraße' , '''Gemeindestraße'' ist eine durch Verwaltungsakt zur Gemeindestrasse gewidmete Straße.');
INSERT INTO widmung_traffic VALUES (9997, 'Non-public road', 'Nicht öffentliche Straße' , 'Nicht öffentliche Straße'' bedeutet, dass hier in Straßenverkehr laubt ist, dieser ber nur zweckgebunden, z. B. in einem Krankenhausgelände, durchgeführt wird.');
INSERT INTO widmung_traffic VALUES (9999, 'Other public road', 'Sonstiges öffentliche Straße' , '''Sonstige öffentliche Straße'' bedeutet, dass es sich um eine öffentliche Straße handelt, die aber keiner der vorhandenen Widmung zugewiesen werden kann.');


ALTER TABLE "ver01_l" ADD CONSTRAINT widmung_fk FOREIGN KEY (wdm) REFERENCES widmung_traffic(code);

-- Attribute: widmung_waterbodies
CREATE TABLE widmung_waterbodies (
                                     code VARCHAR(4) PRIMARY KEY,
                                     name_en TEXT,
                                     name_de TEXT,
                                     definition_de TEXT,
                                     CONSTRAINT check_column_format CHECK (
                                         code ~ '^[0-9]{4}$'
                                         OR LENGTH(code) = 4
)
    );
INSERT INTO widmung_waterbodies VALUES (1310, 'Waterbodies 1. order - federal waterway', 'Gewässer I. Ordnung - Bundeswasserstraße' , '''Gewässer I. Ordnung - Bundeswasserstraße'' ist ein Gewässer, das der Zuständigkeit des Bundes obliegt.');
INSERT INTO widmung_waterbodies VALUES (1320, 'Waterbodies 1. order - state waterway', 'Gewässer I. Ordnung - nach Landesrecht' , '''Gewässer I. Ordnung - nach Landesrecht'' ist ein Gewässer, das der Zuständigkeit des Landes obliegt.');
INSERT INTO widmung_waterbodies VALUES (1330, 'Waterbodies 2. order', 'Gewässer II. Ordnung' , '''Gewässer II. Ordnung'' ist ein Gewässer, für das die Unterhaltungsverbände zuständig sind.');
INSERT INTO widmung_waterbodies VALUES (1340, 'Waterbodies 3. order', 'Gewässer III. Ordnung' , '''Gewässer III. Ordnung'' ist ein Gewässer, das weder zu den Gewässern I. noch II. Ordnung zählt.');


ALTER TABLE "gew01_f" ADD CONSTRAINT widmung_fk FOREIGN KEY (wdm) REFERENCES widmung_waterbodies(code);
ALTER TABLE "gew01_l" ADD CONSTRAINT widmung_fk FOREIGN KEY (wdm) REFERENCES widmung_waterbodies(code);

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
