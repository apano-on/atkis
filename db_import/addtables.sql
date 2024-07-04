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