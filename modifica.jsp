<%@ page import="java.io.*" %>
<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>

<html>
    <head>
        <title>Modifica</title>

         <style>
            table, th, td {
                border: 1px solid black;
            }
            table {
                width: 100%;
            }

            .btn1{
                width: 100%;
            }
        </style>

    </head>
    
    <body>
        <%
        String usr = (String) request.getSession().getAttribute("username");
        if(usr == null){
            response.sendRedirect("index.html");
        }

        String nome = null;
        String descrizione = null;
        String quantita = null;
        String prezzo = null;
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
            nome = request.getParameter("nome");
            descrizione = request.getParameter("descrizione");
            quantita = request.getParameter("quantita");
            prezzo = request.getParameter("prezzo");

 
            connection = DriverManager.getConnection("jdbc:ucanaccess://" + request.getServletContext().getRealPath("/") + "Parrucchiere.accdb");
            
            String queryModifica = "UPDATE Prodotto SET nome = '"+nome+"' , descrizione = '"+descrizione+"' , quantita = '"+quantita+"' , prezzo = '"+prezzo+"' WHERE id = '"+Integer.parseInt(id)+"';";
            String query = "SELECT * FROM Prodotto WHERE proprietario = '"+usr+"';";

            Statement st = connection.createStatement();
            ResultSet r4 = st.executeQuery(query);
  
            st.executeUpdate(queryModifica);
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