CREATE OR REPLACE FUNCTION register_user_on_activity(user_id2 bigint, activity_id2 bigint) RETURNS registration AS $$
	
	DECLARE
	
		insertLine registration%ROWTYPE;
		
		newId bigint;
	
	BEGIN
		
		SELECT * into insertLine
		FROM registration
		WHERE registration.user_id = user_id2 AND registration.activity_id = activity_id2;
		
		IF FOUND THEN
			RAISE NOTICE 'registration_already_exists';
		ELSE
		
			newId = nextval('id_generator');
			
			INSERT INTO registration (id, user_id, activity_id)
			VALUES (newId, user_id2, activity_id2);
			
			SELECT * INTO insertLine
			FROM registration
			WHERE registration.id = newId;
			
			RETURN insertLine;
						
		END IF;

	END;

$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION unregister_user_on_activity(user_id2 bigint, activity_id2 bigint) RETURNS void AS $$

	DECLARE
	
		line registration%ROWTYPE;
	
	BEGIN
	
		SELECT * INTO line
		FROM registration
		WHERE registration.user_id = user_id2 AND registration.activity_id = activity_id2;
		
		IF NOT FOUND THEN
		
			RAISE NOTICE 'registration_not_found';
			
		ELSE
		
			DELETE FROM registration
			WHERE registration.user_id = user_id2 AND registration.activity_id = activity_id2;
			
		END IF;
	
	END;

$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION audit_registration() RETURNS trigger AS $$
	DECLARE
		id bigint;
	BEGIN
		IF (TG_OP = 'INSERT') THEN
			INSERT INTO action_log (id, action_name, entity_name, entity_id, author)
			VALUES (nextval('id_generator'), LOWER(TG_OP), TG_RELNAME, NEW.id, current_user);
			RETURN NEW;
		ELSEIF (TG_OP = 'DELETE') THEN
			INSERT INTO action_log (id, action_name, entity_name, entity_id, author)
			VALUES (nextval('id_generator'), LOWER(TG_OP), TG_RELNAME, OLD.id, current_user);
			RETURN OLD;
		END IF;
		
		RETURN NULL;
	END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS action_log_stamp_register ON registration;

CREATE TRIGGER action_log_stamp_register
	AFTER INSERT OR DELETE ON registration
	FOR EACH ROW EXECUTE PROCEDURE audit_registration();