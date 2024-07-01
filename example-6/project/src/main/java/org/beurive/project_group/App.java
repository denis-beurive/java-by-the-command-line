package org.beurive.project_group;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.core.JsonProcessingException;

public class App 
{
    public static void main( String[] args )
    {
        ObjectMapper mapper = new ObjectMapper(); // create once, reuse
        MyValue value;
        try {
           value = mapper.readValue("{\"name\":\"Bob\", \"age\":13}", MyValue.class);
        } catch(JsonProcessingException e) {
           System.out.printf("ERROR: %s\n", e.toString());
           return;
        }
        System.out.printf("name = %s\n", value.name);
        System.out.printf("age = %d\n", value.age);
        return;
    }
}
