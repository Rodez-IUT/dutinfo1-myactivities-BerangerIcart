CREATE OR REPLACE FUNCTION get_default_owner() RETURNS "user" AS $$

	DECLARE
		userObj "user"%ROWTYPE;
	BEGIN

		SELECT * INTO userObj FROM "user" WHERE username = 'Default Owner';
		
		IF FOUND THEN
			RETURN userObj;
		END IF;
		
		INSERT INTO "user" (id, username) VALUES (1, 'Default Owner');
		SELECT * INTO userObj FROM "user" WHERE username = 'Default Owner';
		RETURN userObj;
		
	END
$$ LANGUAGE 'plpgsql';