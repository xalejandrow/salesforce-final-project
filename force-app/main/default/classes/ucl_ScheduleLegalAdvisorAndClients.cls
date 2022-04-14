public class ucl_ScheduleLegalAdvisorAndClients implements Schedulable{

    public void execute(SchedulableContext ctx){
        ucl_HerokuApiHandler.getHerokuData();   
    }
}
