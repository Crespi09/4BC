<%@ page import="java.io.*" %>
<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>

<html>
    <head>
        <title>Sell</title>

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
        <h1>SELL</h1>

        <form action = "sell.jsp" method = "POST">
            Nome: <input type= "text" id = "nome" name = "nome" placeholder = "Nome" required>
            Descrizione: <input type= "text" id = "descrizione" name = "descrizione" placeholder = "Descrizione" required>
            Quantita': <input type= "number" id = "quantita" name = "quantita" placeholder = "Quantita'" required>
            Prezzo: <input type= "number" id = "prezzo" name = "prezzo" placeholder = "Prezzo" step="0.01" required>

            <input type = "submit" id = "btn" name = "btn" value = "Aggiungi Prodotto" onclick ="Aggiungi()">        
        </form>

        <%
        String usr = (String) request.getSession().getAttribute("username");
        String idProprietario = (String)request.getSession().getAttribute("id");
        System.out.println("idProp: " + idProprietario);

        if((usr == null) || (idProprietario == null)){
            response.sendRedirect("index.html");
        }

        String DRIVER = "net.ucanaccess.jdbc.UcanaccessDriver";
        
        String nome = null;
        String descrizione;
        String quantita = null;
        String prezzo = null;
        String controlloModifica = "false";

        Connection connection=null;

        try{
            Class.forName(DRIVER);
        }
        catch (ClassNotFoundException e) {
            out.println("Errore: Impossibile caricare il Driver Ucanaccess");
        }
        try{
            
            nome = request.getParameter("nome");
            descrizione = request.getParameter("descrizione");
            quantita = request.getParameter("quantita");
            prezzo = request.getParameter("prezzo");

            if(request.getParameter("controlloModifica") != null){
                controlloModifica = request.getParameter("controlloModifica");
            }
            
            System.out.println(controlloModifica);


            connection = DriverManager.getConnection("jdbc:ucanaccess://" + request.getServletContext().getRealPath("/") + "Parrucchiere.accdb");
            
            String query = "SELECT * FROM Prodotto WHERE idProp = '"+idProprietario+"';";
            String queryControllo = "SELECT nomeProd,idProp FROM Prodotto WHERE nomeProd = '"+nome+"' AND idProp = '"+idProprietario+"';";
            String queryInserimento = "INSERT INTO Prodotto(nomeProd,descrizione,quantita,prezzo,idProp) VALUES ('"+nome+"' , '"+descrizione+"' , '"+ quantita+"' , '"+prezzo+"', '"+idProprietario+"')";
            
            //String queryProdottiVenduti = "SELECT Cliente.nome, Cliente.cognome, Prodotto.nomeProd, Comprare.quantita FROM Prodotto,Comprare,Cliente WHERE (Comprare.idProdotto = Prodotto.ID) AND (Comprare.idCliente = Cliente.ID) AND (Prodotto.idProp) = '"+idProprietario+"';";
            String queryProdottiVenduti = "SELECT Cliente.nome, Cliente.cognome, Prodotto.nomeProd, CronologiaComprati.quantita, CronologiaComprati.data FROM Cliente, Prodotto, CronologiaComprati WHERE (Cliente.ID = CronologiaComprati.idCliente) AND (Prodotto.id = CronologiaComprati.idProdotto) AND (Prodotto.idProp = '"+idProprietario+"');";

            Statement st = connection.createStatement();
            ResultSet r1 = st.executeQuery(queryControllo);
            ResultSet r3 = st.executeQuery(query);
            ResultSet r4 = st.executeQuery(queryProdottiVenduti);


            if((nome != null) || (descrizione != null) || (quantita != null) || (prezzo !=null)){
                if(r1.next()){
                    out.println("<p>Prodotto già in vendita'</p>");
                }else{
                    st.executeUpdate(queryInserimento);
                    response.sendRedirect("sell.jsp"); 
                }
            }else{
                out.println("Inserisci i valori nei campi"); 
            }

            
            out.println("<p>Prodotti in magazzino: </p>");

            if(!controlloModifica.equals("true")){
                out.println("<table>");

                    out.println("<tr>");
                        out.println("<th>Nome</th>");
                        out.println("<th>Descrizione</th>");
                        out.println("<th>Quantita'</th>");
                        out.println("<th>Prezzo</th>");
                        
                        out.println("<th> <a href = 'sell.jsp?controlloModifica=true'><button class = 'btn1'>Modifica</button></a></th>");

                    out.println("</tr>");
                    
                    while(r3.next()){   
                        String idProd = r3.getString(1); 
                
                        out.println("<tr>");
                            out.println("<td>"+r3.getString("nomeProd")+ "</td>");
                            out.println("<td>"+r3.getString("descrizione")+ "</td>");
                            out.println("<td>"+r3.getString("quantita")+ "</td>");
                            out.println("<td>"+r3.getString("prezzo")+ " €</td>");
                                
                            //elimina
                            out.println("<form action='elimina.jsp' method='POST'>");
                                out.println("<input type='hidden' id='idProd' name='idProd' value = '"+idProd+"'>");
                                out.println("<input type='hidden' id='tipo' name='tipo' value = 'sell'>");
                                
                                out.println("<td> <input type= 'submit' class = 'btn1' value= 'Elimina'></td>");
                            out.println("</form>");

                        out.println("</tr>");
                    }
                    
                    out.println("</table>");

                    out.println("<br><p>Prodotti Venduti: </p>");
                    out.println("<table>");
                        out.println("<tr>");
                        out.println("<th>Nome Acquirente</th>");
                        out.println("<th>Nome Prodotto</th>");
                        out.println("<th>Quantita'</th>");
                        out.println("<th>Data Aquisto</th>");
                    out.println("</tr>");

                    while(r4.next()){
                        String nomeCliente = r4.getString("Cliente.nome") +" "+r4.getString("Cliente.cognome");
                        
                        String data = r4.getString("CronologiaComprati.data");
                        String[] split = data.split(" ");
                        String data1 = split[0];

                        out.println("<tr>");
                            out.println("<td>"+nomeCliente+ "</td>");
                            out.println("<td>"+r4.getString("Prodotto.nomeProd")+ "</td>");
                            out.println("<td>"+r4.getString("CronologiaComprati.quantita")+ "</td>");
                            out.println("<td>"+split[0]+ "</td>");
                        out.println("</tr>");
                    }

                out.println("</table>");

            }else{
                out.println("<table>");

                out.println("<tr>");
                    out.println("<th>Nome</th>");
                    out.println("<th>Descrizione</th>");
                    out.println("<th>Quantita'</th>");
                    out.println("<th>Prezzo</th>");
                    out.println("<th> <a href = 'sell.jsp?controlloModifica=false'><button class = 'btn1'>Indietro</button></a></th>");
                out.println("</tr>");
                
                while(r3.next()){   
                    String idProd = r3.getString("ID"); 
                    System.out.println("id:"+idProd);
                        out.println("<tr>");
                            out.println("<form action='modifica.jsp' method = 'post'>");
                                out.println("<td><input type = 'text' id = 'nome' name = 'nome' value = '"+r3.getString("nomeProd")+"'></td>");
                                out.println("<td><input type = 'text' id = 'descrizione' name = 'descrizione' value = '"+r3.getString("descrizione")+"'></td>");
                                out.println("<td><input type = 'text' id = 'quantita' name = 'quantita' value = '"+r3.getString("quantita")+"'></td>");
                                out.println("<td><input type = 'text' id = 'prezzo' name = 'prezzo' value = '"+r3.getString("quantita")+"'></td>");
                                
                                out.println("<input type='hidden' id='idProd' name='idProd' value = '"+idProd+"'>");
                                out.println("<input type='hidden' id='idProp' name='idProp' value = '"+idProprietario+"'>");
                                out.println("<input type='hidden' id='tipo' name='tipo' value = 'sell'>");

                                out.println("<td> <input type= 'submit' class = 'btn1' value= 'Salva'></td>");
                            out.println("</form>"); 
                            
                        out.println("</tr>");
                }
                out.println("</table>");
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

        <br> <br>
        <a href = "loginOwner.jsp"> 
            <input type="button" value="Home"/> <br> 
        </a>

    </body>

</html>