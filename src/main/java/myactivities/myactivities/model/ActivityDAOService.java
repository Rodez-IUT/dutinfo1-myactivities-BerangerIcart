package myactivities.myactivities.model;

import org.apache.ibatis.annotations.*;
import org.apache.ibatis.mapping.StatementType;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Mapper @Service
public interface ActivityDAOService {

    @Select(value= "{CALL add_activity(" +
            "#{title, mode=IN, jdbcType=VARCHAR, javaType=String}," +
            "#{description, mode=IN, jdbcType=VARCHAR, javaType=String}," +
            "#{ownerId, mode=IN, jdbcType=BIGINT, javaType=Long})}")
    @Results(id = "activity", value = {
            @Result(property = "creationDate", column = "creation_date"),
            @Result(property = "modificationDate", column = "modification_date"),
            @Result(property = "ownerId", column = "owner_id")
    })
    @Options(statementType = StatementType.CALLABLE)
    public Activity addActivity(String title, String description, Long ownerId);

    @Select(value = "select act.*, username from activity act " +
            "left join \"user\" owner " +
            "on act.owner_id = owner.id where act.id =#{id}")
    @ResultMap("activity")
    public Activity getActivityForId(Long id);

    @Insert(value= "{CALL find_all_activities(#{result,mode=OUT, jdbcType=OTHER, javaType=java.sql.ResultSet, resultMap=activity})}")
    @Options(statementType = StatementType.CALLABLE)
    public void findAllActivitiesWithProcedureCall(Map<String,List<Activity>> parameters);

//    @Insert(value= "{CALL find_all_activities(#{result,mode=OUT, jdbcType=CURSOR})}")
//    @Options(statementType = StatementType.CALLABLE)
//    @ResultType(Activity.class)
//    @Results(
//    {   
//     @Result(property="id", column="id"),
//     @Result(property="title", column="title"),
//     @Result(property="description", column="description"),
//     @Result(property="creation_date", column="creation_date"),
//     @Result(property="modification_date", column="modification_date"),
//     @Result(property="owner_id", column="owner_id"),
//    })
    @Select(value = "SELECT activity.id, activity.title, \"user\".username" + 
	        "\r\nFROM activity" + 
	        "\r\nLEFT JOIN \"user\" ON \"user\".id = activity.owner_id" + 
	        "\r\nORDER BY title ASC, \"user\".username ASC")
    @ResultMap("activity")
    public List<Activity> findAllActivities();
    
    @Select(value= "{CALL fix_activities_without_owner()}")
    @Options(statementType = StatementType.CALLABLE)
    @ResultMap("activity")
    public void fixActivities();
}