CREATE OR REPLACE FUNCTION audit_actionLog() RETURNS trigger AS $$
	DECLARE
		id bigint;
	BEGIN
	
		id := OLD.id;
			
		INSERT INTO action_log (id, action_name, entity_name, entity_id, author)
		VALUES (nextval('id_generator'), LOWER(TG_OP), TG_RELNAME, id, 'postgres');
		
		RETURN NULL;
	
	END;

$$ LANGUAGE plpgsql;

CREATE TRIGGER action_log_stamp
	AFTER DELETE ON activity
	FOR EACH ROW EXECUTE PROCEDURE audit_actionLog();