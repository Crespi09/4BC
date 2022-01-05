<%@ page import="java.io.*" %>
<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<html>
    <head>
        <title>Booking</title>
    </head>
    
    <body>
        <h1>Booking</h1>
        <p>Visualizzazione tabella con i Parrucchieri disponibili, con possibilita' di scegliere quale andare a prenotare.</p>
        
        <a href = "loginCliente.html"> 
            <input type="button" value="Indietro"/> <br> 
        </a>
        
        <%
        String DRIVER = "net.ucanaccess.jdbc.UcanaccessDriver";
        
        Connection connection=null;

        try{
            Class.forName(DRIVER);
        }
        catch (ClassNotFoundException e) {
            out.println("Errore: Impossibile caricare il Driver Ucanaccess");
        }
        try{
            
            connection = DriverManager.getConnection("jdbc:ucanaccess://" + request.getServletContext().getRealPath("/") + "DatiUtenti.accdb");
            String query = "SELECT * FROM Proprietari"; 
            
            Statement st = connection.createStatement();
            ResultSet result = st.executeQuery(query);

        }
        catch(Exception e){
            out.println(e);
        }
        finally{
            if(connection != null){

                try{
                    connection.close();
                }
                catch(Exception e){out.println("Errore nella chiusura della connessione");}
            }
        }
        %>

    </body>



</html>