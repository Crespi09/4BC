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
        
        String tipo = null;


        String idProdotto = null;
        String idGiorno = null;
        String idProdCarrello = null;
        String qtaProd = null;

        String DRIVER = "net.ucanaccess.jdbc.UcanaccessDriver";
        Connection connection=null;

        try{
            Class.forName(DRIVER);
        }
        catch (ClassNotFoundException e) {
            out.println("Errore: Impossibile caricare il Driver Ucanaccess");
        }
        try{
            
            tipo = request.getParameter("tipo");

            connection = DriverManager.getConnection("jdbc:ucanaccess://" + request.getServletContext().getRealPath("/") + "Parrucchiere.accdb");            
            
            Statement st= connection.createStatement();
    
            switch (tipo){
                case "sell":
                    idProdotto = request.getParameter("idProd");
                    String queryEliminaProdotto = "DELETE FROM Prodotto WHERE ID = '"+Integer.parseInt(idProdotto)+"';";
                    st.executeUpdate(queryEliminaProdotto);
                    idProdotto = null;
                    response.sendRedirect("sell.jsp");
                break;

                case "orario":
                    idGiorno = request.getParameter("idGiorno"); 
                    String queryEliminaOrario = "DELETE FROM Orari WHERE ID = '"+Integer.parseInt(idGiorno)+"';";
                    st.executeUpdate(queryEliminaOrario);
                    idGiorno = null;
                    response.sendRedirect("orariOwner.jsp");
                break;

                case "carrello":
                    idProdCarrello = request.getParameter("idProdCarrello");
                    qtaProd = request.getParameter("qtaProd");
                    String querySelectQta = "SELECT quantita FROM Prodotto WHERE id = '"+idProdCarrello+"';";
                    String queryEliminaProdottoCarrello = "DELETE FROM Comprare WHERE idProdotto = '"+Integer.parseInt(idProdCarrello)+"';";
                    ResultSet r1 = st.executeQuery(querySelectQta);
                    r1.next();
                    int qtaProdCarrello = Integer.parseInt(r1.getString("quantita"));    
                    String queryModifica = "UPDATE Prodotto SET quantita = '"+(qtaProdCarrello + Integer.parseInt(qtaProd))+"' WHERE ID = '"+Integer.parseInt(idProdCarrello)+"';";
                    
                    st.executeUpdate(queryEliminaProdottoCarrello);
                    st.executeUpdate(queryModifica);
                    idProdCarrello = null;
                    //queryUpdateQTAProdotti = null;
                    response.sendRedirect("carrello.jsp");
                break;

                default:
                    out.println("");


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