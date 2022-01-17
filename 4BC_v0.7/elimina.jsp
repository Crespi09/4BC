<%@ page import="java.io.*" %>
<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>

<html>
    <head>
        <title>Elimina</title>
    </head>
    
    <body>
        
        <%
        String usr = (String) request.getSession().getAttribute("username");
        String id = null;
        String DRIVER = "net.ucanaccess.jdbc.UcanaccessDriver";
        
        Connection connection=null;

        try{
            Class.forName(DRIVER);
        }
        catch (ClassNotFoundException e) {
            out.println("Errore: Impossibile caricare il Driver Ucanaccess");
        }
        try{
            
            id = request.getParameter("idProd");
            out.println("<p>ID: "+id+"</p>");

            connection = DriverManager.getConnection("jdbc:ucanaccess://" + request.getServletContext().getRealPath("/") + "DatiUtenti.accdb");
        
            String queryElimina = "DELETE FROM Prodotti WHERE id = '"+id+"';";
            Statement st= connection.createStatement();
            st.executeUpdate(queryElimina);
            response.sendRedirect("sell.jsp");
        
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