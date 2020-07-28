CREATE TABLE report (
id		SERIAL	PRIMARY KEY,					-- "serial" originally
mindate		TIMESTAMP WITH TIME ZONE  NOT NULL  DEFAULT NOW(),
maxdate		TIMESTAMP WITH TIME ZONE,
domain		TEXT  NOT NULL,
org		TEXT  NOT NULL,
reportid	TEXT  NOT NULL,
email		TEXT,
extra_contact_info TEXT,
policy_adkim	TEXT,
policy_aspf	TEXT,
policy_p	TEXT,
policy_sp	TEXT,
policy_pct	TEXT
);

CREATE UNIQUE INDEX i_report_domain ON report (domain, reportid);

CREATE OR REPLACE RULE update_report_stamp AS ON UPDATE TO report
    DO ALSO  UPDATE report SET mindate=NOW() WHERE id = NEW.id;


CREATE TYPE disposition_type 	AS ENUM('none','quarantine','reject');
CREATE TYPE dkim_res_type    	AS ENUM('none','pass','fail','neutral','policy','temperror','permerror');
CREATE TYPE spf_res_type	AS ENUM('none','neutral','pass','fail','softfail','temperror','permerror','unknown');
CREATE TYPE align_type		AS ENUM('fail','pass','unknown');

CREATE TABLE rptrecord (
id		SERIAL  PRIMARY KEY,
report_id	INTEGER  NOT NULL  REFERENCES report,			-- "serial" again
ip		INET,
rcount		INTEGER  NOT NULL,
disposition	disposition_type,
reason		TEXT,
dkimdomain	TEXT,
dkimresult	dkim_res_type,
spfdomain	TEXT,
spfresult	spf_res_type,
spf_align	align_type  NOT NULL,
dkim_align 	align_type  NOT NULL,
identifier_hfrom TEXT
);



CREATE TABLE rptxml (
id		SERIAL  PRIMARY KEY,
report_id	INTEGER  NOT NULL  REFERENCES report,
raw_xml		TEXT,
stamp		TIMESTAMP WITH TIME ZONE  DEFAULT NOW()
);
