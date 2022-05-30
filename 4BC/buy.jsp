<%@ page import="java.io.*" %>
<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<html>
    <head>
        <title>Buy</title>
    </head>

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
    
    <body>
        <h1>BUY</h1>
        <p> Visualizzazione tabella con prodotti disponibili all'acquisto, con possibilita' di scegliere quale andare a comprare.</p> <br>

        <%
            String usr = (String) request.getSession().getAttribute("username");
            String idCliente = (String) request.getSession().getAttribute("id"); 
            if(usr == null || idCliente == null){
                 response.sendRedirect("index.html");
            }

            String aggiuntaCarrello = "false";
            String idProd = null;
            String quantita = null;
            
            String DRIVER = "net.ucanaccess.jdbc.UcanaccessDriver";
            Connection connection=null;

        try{
            Class.forName(DRIVER);
        }
        catch (ClassNotFoundException e) {
            out.println("Errore: Impossibile caricare il Driver Ucanaccess");
        }
        try{
            
            if(request.getParameter("aggiuntaCarrello") != null){
                aggiuntaCarrello = request.getParameter("aggiuntaCarrello");
            }
            if(request.getParameter("idProd") != null){
                idProd = request.getParameter("idProd");
            }
            if(request.getParameter("quantita") != null){
                quantita = request.getParameter("quantita");
            }
            
            System.out.println("IDCLIENTE: " + idCliente); //debug
            System.out.println("IDPRODOTTO: " + idProd); //debug

            connection = DriverManager.getConnection("jdbc:ucanaccess://" + request.getServletContext().getRealPath("/") + "Parrucchiere.accdb");
            String querySelezionaProdotti = "SELECT * FROM Prodotto WHERE (Prodotto.quantita <> NULL) OR (Prodotto.quantita <> 0)"; 
            

            Statement st = connection.createStatement();
            ResultSet r = st.executeQuery(querySelezionaProdotti);
            

            if(!aggiuntaCarrello.equals("true")){
            out.println("<table>");
                out.println("<tr>");
                    out.println("<th>Nome</th>");
                    out.println("<th>Descrizione</th>");
                    out.println("<th>Quantita' Disponibile</th>");
                    out.println("<th>Prezzo</th>");
                    out.println("<th>Quantita'</th>");
                out.println("</tr>");
                
                while(r.next()){   
                    idProd = r.getString("id"); 
                   
                    String querySelezioneQuantita = "SELECT quantita FROM Prodotto WHERE ID = '"+idProd+"';";
                    ResultSet r3 = st.executeQuery(querySelezioneQuantita);

                    while(r3.next()){
                        int quantitaMax = Integer.parseInt(r3.getString("quantita"));
                            out.println("<tr>");
                                out.println("<td>"+r.getString("nomeProd")+ "</td>");
                                out.println("<td>"+r.getString("descrizione")+ "</td>");
                                out.println("<td>"+r.getString("quantita")+ "</td>");
                                out.println("<td>"+r.getString("prezzo")+ " €</td>");

                                out.println("<form action='buy.jsp' method='POST'>");
                                    aggiuntaCarrello = "true";
                                    out.println("<td><input type = 'number' id= 'quantita' name = 'quantita' min = '1' max = '"+quantitaMax+"' placeholder = 'quantita'></td>");    
                                    out.println("<input type='hidden' id='idProd' name='idProd' value = '"+idProd+"'>");
                                    out.println("<input type='hidden' id='aggiuntaCarrello' name='aggiuntaCarrello' value = '"+aggiuntaCarrello+"'>");

                                    out.println("<td> <input type= 'submit' class = 'btn1' value= 'Aggiungi al Carrello'></td>");
                                out.println("</form>");

                            out.println("</tr>");
                    }
                }
            out.println("</table>");
            out.println("<br><a href = 'carrello.jsp'><button class = 'btn2'>Carrello</button></a><br>");
            }else{
                String queryAggiungiProdottoCarrello = "INSERT INTO Comprare (idCliente, idProdotto, quantita) VALUES ('"+idCliente+"', '"+idProd+"', '"+quantita+"');";
                String queryVerifica = "SELECT * FROM Comprare WHERE idCliente = '"+idCliente+"' AND  idProdotto = '"+idProd+"';";
                String querySelectQuantitaProdotti = "SELECT quantita FROM Prodotto WHERE id = '"+idProd+"';";

                Statement st1 = connection.createStatement();
                ResultSet r1 = st1.executeQuery(queryVerifica);
                ResultSet r2 = st1.executeQuery(querySelectQuantitaProdotti);
                
                
                if(r1.next() && r2.next()){
                    int quantitaAppoggio = Integer.parseInt(r1.getString("quantita"));
                    int quantitaAppoggioProdotti = Integer.parseInt(r2.getString("quantita")); //
                    String queryUpdateComprare = "UPDATE Comprare SET quantita = '"+(quantitaAppoggio + Integer.parseInt(quantita))+"' WHERE idCliente = '"+idCliente+"' AND  idProdotto = '"+idProd+"';";
                    String queryUpdateProdotti = "UPDATE Prodotto SET quantita = '"+(quantitaAppoggioProdotti - Integer.parseInt(quantita))+"' WHERE id = '"+idProd+"';"; //
                    st1.executeUpdate(queryUpdateComprare);
                    st1.executeUpdate(queryUpdateProdotti); //
                }else if (r2.next()){
                    int quantitaAppoggioProdotti = Integer.parseInt(r2.getString("quantita")); //
                    String queryUpdateProdotti = "UPDATE Prodotto SET quantita = '"+(quantitaAppoggioProdotti - Integer.parseInt(quantita))+"' WHERE id = '"+idProd+"';";  //

                    st1.executeUpdate(queryUpdateProdotti); //
                    st1.executeUpdate(queryAggiungiProdottoCarrello);
                }
                
                aggiuntaCarrello = "false";
                response.sendRedirect("buy.jsp"); 
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

        <br>
        <a href = "loginCliente.jsp"> 
            <input type="button" value="Home"/> <br> 
        </a>
    </body>

</html>