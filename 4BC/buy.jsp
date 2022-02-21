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
            
            System.out.println("IDCLIENTE: " + idCliente);
            System.out.println("IDPRODOTTO: " + idProd);

            connection = DriverManager.getConnection("jdbc:ucanaccess://" + request.getServletContext().getRealPath("/") + "DatiUtenti.accdb");
            String querySelezionaProdotti = "SELECT * FROM Prodotti"; 
        
            Statement st = connection.createStatement();
            ResultSet r = st.executeQuery(querySelezionaProdotti);

            if(!aggiuntaCarrello.equals("true")){
            out.println("<table>");

                out.println("<tr>");
                    out.println("<th>Nome</th>");
                    out.println("<th>Descrizione</th>");
                    out.println("<th>Quantita'</th>");
                    out.println("<th>Prezzo</th>");
                    out.println("<th>Quantita'</th>");
                out.println("</tr>");
                
                while(r.next()){   
                     idProd = r.getString(1); 
                        out.println("<tr>");
                            out.println("<td>"+r.getString(2)+ "</td>");
                            out.println("<td>"+r.getString(4)+ "</td>");
                            out.println("<td>"+r.getString(6)+ "</td>");
                            out.println("<td>"+r.getString(7)+ " €</td>");

                            
                            
                            //manca quantità
                            out.println("<form action='buy.jsp' method='POST'>");
                                aggiuntaCarrello = "true";
                                out.println("<td><input type = 'number' id= 'quantita' name = 'quantita' min = '1' max = '100' placeholder = 'quantita'></td>");    
                                out.println("<input type='hidden' id='idProd' name='idProd' value = '"+idProd+"'>");
                                out.println("<input type='hidden' id='aggiuntaCarrello' name='aggiuntaCarrello' value = '"+aggiuntaCarrello+"'>");

                                out.println("<td> <input type= 'submit' class = 'btn1' value= 'Aggiungi al Carrello'></td>");
                            out.println("</form>");

                        out.println("</tr>");
                }
            out.println("</table>");
            }else{
                String queryAggiungiProdottoCarrello = "INSERT INTO Comprare (idCliente, idProdotto, quantita) VALUES ('"+idCliente+"', '"+idProd+"', '"+quantita+"');";
                String queryVerifica = "SELECT * FROM Comprare WHERE idCliente = '"+idCliente+"' AND  idProdotto = '"+idProd+"';";
                String queryUpdateComprare = "UPDATE Comprare SET quantita = quantita + '"+Integer.parseInt(quantita)+"' WHERE idCliente = '"+idCliente+"' AND  idProdotto = '"+idProd+"';";
                
                //int quantitaAppoggio = Integer.parseInt(quantita);
                Statement st1 = connection.createStatement();
                //verificare se il prodotto da inserire e l'id del cliente siano già presenti nella tabella Comprare, se si modificare con UPDATE la quantità
                ResultSet r1 = st1.executeQuery(queryVerifica);
                if(r1.next()){
                    /*
                    System.out.println("QUANTITA APPOGGIO1: "+ quantitaAppoggio);
                    quantitaAppoggio = quantitaAppoggio + Integer.parseInt(quantita);
                    System.out.println("QUANTITA: "+quantita);
                    System.out.println("QUANTITA APPOGGIO2: " + quantitaAppoggio);
                    //String queryUpdateComprare = "UPDATE Comprare SET quantita =  '"+quantitaAppoggio+"' WHERE idCliente = '"+idCliente+"' AND  idProdotto = '"+idProd+"';";
                    */
                    st1.executeUpdate(queryUpdateComprare);
                }else{
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
            <input type="button" value="Indietro"/> <br> 
        </a>
    </body>

</html>