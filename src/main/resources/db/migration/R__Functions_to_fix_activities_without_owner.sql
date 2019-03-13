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

CREATE OR REPLACE FUNCTION fix_activities_without_owner() RETURNS SETOF activity AS $$

	DECLARE
		userObj "user"%rowtype;
	BEGIN
		userObj := get_default_owner();
		
		RETURN QUERY UPDATE activity
		             SET owner_id = userObj.id
		             WHERE owner_id IS NULL
		             RETURNING *;
		
	END;

$$ LANGUAGE plpgsql;