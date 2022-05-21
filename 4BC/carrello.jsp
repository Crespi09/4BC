<%@ page import="java.io.*" %>
<%@ page import="java.sql.*" %>
<%@ page import = "java.time.format.DateTimeFormatter" %>
<%@ page import = "java.time.LocalDateTime" %>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>

<!--FARE QUERY DOVE VADO A VISUALIZZARE LA TABELLA Comprare, AGGIUNGERE POI UN TASTO PAGA, ATTRAVERSO IL QUALE ATTUARE IL PAGAMENTO -->
<html>
    <head>
        <title>Carrello</title>

        <style>
            table, th, td {
                border: 1px solid black;
            }
            table {
                width: 50%;
            }
            .btn1{
                width: 100%;
            }
        </style>

    </head>
    
    <body>
        
        <%
        String usr = (String) request.getSession().getAttribute("username");
        String idCliente = (String) request.getSession().getAttribute("id");
        if(usr == null || idCliente == null){
            response.sendRedirect("index.html");
        }
        
        DateTimeFormatter dtf = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss");  
        LocalDateTime now = LocalDateTime.now();  

        out.println("<h1> Prodotti nel Carrello di "+usr+": </h1><br>");

        String idProd = null;
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
            
            connection = DriverManager.getConnection("jdbc:ucanaccess://" + request.getServletContext().getRealPath("/") + "Parrucchiere.accdb");
        
            String queryProdottiAcquisiti = "SELECT Prodotto.nomeProd, Comprare.quantita FROM Prodotto INNER JOIN Comprare ON Prodotto.ID = Comprare.idProdotto WHERE Comprare.idCliente = '"+idCliente+"';";
            String querySelectComprare = "SELECT * FROM Comprare WHERE idCliente = '"+idCliente+"';";
            
            Statement st= connection.createStatement();
            ResultSet r1 = st.executeQuery(queryProdottiAcquisiti);
            ResultSet r2 = st.executeQuery(querySelectComprare);

            out.println("<table>");

                out.println("<tr>");
                    out.println("<th>Nome Prodotto</th>");
                    out.println("<th>Quantita'</th>");
                out.println("</tr>");   

            while(r1.next() && r2.next()){
                idProd = r2.getString("Comprare.idProdotto");
                System.out.println("aaaaaaaaaaaaa:" +idProd);
                qtaProd = r2.getString("Comprare.quantita");
                
                out.println("<tr>");
                    out.println("<td>"+r1.getString("Prodotto.nomeProd")+ "</td>");
                    out.println("<td>"+r1.getString("Comprare.quantita")+ "</td>");
                    
                    out.println("<form action='elimina.jsp' method='POST'>");
                                out.println("<input type='hidden' id='idProdCarrello' name='idProdCarrello' value = '"+idProd+"'>");
                                
                                out.println("<input type= 'hidden' id= 'qtaProd' name = 'qtaProd' value = '"+qtaProd+"'>");
                                out.println("<td> <input type= 'submit' class = 'btn1' value= 'Elimina'></td>");
                    out.println("</form>");
                out.println("</tr>");
            }
            out.println("</table>");
            
            out.println("<form action = 'carrello.jsp' method='POST'>");  
                out.println("<input type='hidden' id='pagamento' name='pagamento' value = 'y'>");
                out.println("<td> <input type= 'submit' class = 'btn2' value= 'Effettua Pagamento'></td>");
            out.println("</form>");
            
            //TODO una volta effettuato il pagamento andare ad eliminare i prodotti comprari
            String alertS = (String) request.getParameter("pagamento");
            if ( alertS != null && (alertS).equals("y")) { %>
                <script> alert("Pagamento Effettuato");</script>
                <% 
                    alertS = null;

                    String querySelectID = "SELECT idProdotto FROM Comprare";

                    ResultSet r3 = st.executeQuery(querySelectID);

                    while(r3.next()){

                        idProd = r3.getString("idProdotto");

                        String querySelezioneQuantitaProdotto = "SELECT quantita FROM Prodotto WHERE ID = '"+idProd+"' ";
                        String querySelezioneQuantitaComprare = "SELECT quantita FROM Comprare WHERE idProdotto = '"+idProd+"' ";

                        ResultSet r4 = st.executeQuery(querySelezioneQuantitaProdotto);
                        ResultSet r5 = st.executeQuery(querySelezioneQuantitaComprare);

                        r4.next();
                        r5.next();

                        int qtProdotto = Integer.parseInt(r4.getString("quantita"));
                        int qtComprare = Integer.parseInt(r5.getString("quantita"));

                        
                        String queryUpdateProdotti = "UPDATE Prodotto SET quantita = '"+(qtProdotto - qtComprare)+"' WHERE id = '"+idProd+"';";
                        String queryDeleteRowComprare = "DELETE FROM Comprare WHERE idProdotto = '"+idProd+"';";
                        String queryUpdateComprati = "INSERT INTO CronologiaComprati (idCliente, idProdotto, quantita, data) VALUES ('"+idCliente+"', '"+idProd+"', '"+qtComprare+"' ,'"+now+"' )";
                        
                        st.executeUpdate(queryUpdateProdotti);
                        st.executeUpdate(queryDeleteRowComprare);
                        st.executeUpdate(queryUpdateComprati);
                        
                    }

            }   %> 
            
        <%

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

        <a href = "buy.jsp"> 
            <input type="button" value="Indietro"/> <br> 
        </a>

    </body>

</html>