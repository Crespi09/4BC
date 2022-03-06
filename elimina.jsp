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
        if(usr == null){
            response.sendRedirect("index.html");
        }
        
        String idProdotto = null;
        String idGiorno = null;
        String idProdCarrello = null;

        String DRIVER = "net.ucanaccess.jdbc.UcanaccessDriver";
        Connection connection=null;

        try{
            Class.forName(DRIVER);
        }
        catch (ClassNotFoundException e) {
            out.println("Errore: Impossibile caricare il Driver Ucanaccess");
        }
        try{
            
            idGiorno = request.getParameter("idGiorno");  
            idProdotto = request.getParameter("idProd");
            idProdCarrello = request.getParameter("idProdCarrello");
            
            connection = DriverManager.getConnection("jdbc:ucanaccess://" + request.getServletContext().getRealPath("/") + "DatiUtenti.accdb");
        
            String queryEliminaProdotto = "DELETE FROM Prodotti WHERE id = '"+idProdotto+"';";
            String queryEliminaOrario = "DELETE FROM Orari WHERE codice = '"+idGiorno+"';";
            String queryEliminaProdottoCarrello = "DELETE FROM Comprare WHERE idProdotto = '"+idProdCarrello+"';";
            Statement st= connection.createStatement();
            
            if(idGiorno != null){
                st.executeUpdate(queryEliminaOrario);
                idGiorno = null;
                response.sendRedirect("orariOwner.jsp");
            }
            if(idProdotto != null){
                st.executeUpdate(queryEliminaProdotto);
                idProdotto = null;
                response.sendRedirect("sell.jsp");
            }
            if(idProdCarrello != null){
                st.executeUpdate(queryEliminaProdottoCarrello);
                idProdCarrello = null;
                response.sendRedirect("carrello.jsp");
            }
        
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