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


            connection = DriverManager.getConnection("jdbc:ucanaccess://" + request.getServletContext().getRealPath("/") + "DatiUtenti.accdb");
            
            String query = "SELECT * FROM Prodotti WHERE idProp = '"+idProprietario+"';";
            String queryControllo = "SELECT nome,proprietario FROM Prodotti WHERE nome = '"+nome+"' AND idProp = '"+idProprietario+"';";
            String queryInserimento = "INSERT INTO Prodotti(nome,descrizione,quantita,prezzo,proprietario,idProp) VALUES ('"+nome+"' , '"+descrizione+"' , '"+ quantita+"' , '"+prezzo+"' , '"+usr+"' , '"+idProprietario+"')";

            Statement st = connection.createStatement();
            ResultSet r1 = st.executeQuery(queryControllo);
            ResultSet r3 = st.executeQuery(query);


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

            
            out.println("<p>Prodotti in vendita': </p>");

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
                            out.println("<td>"+r3.getString(2)+ "</td>");
                            out.println("<td>"+r3.getString(4)+ "</td>");
                            out.println("<td>"+r3.getString(6)+ "</td>");
                            out.println("<td>"+r3.getString(7)+ " €</td>");
                                
                            //elimina
                            out.println("<form action='elimina.jsp' method='POST'>");
                                out.println("<input type='hidden' id='idProd' name='idProd' value = '"+idProd+"'>");
                                out.println("<td> <input type= 'submit' class = 'btn1' value= 'Elimina'></td>");
                            out.println("</form>");

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
                    String idProd = r3.getString(1); 
                    System.out.println("id:"+idProd);
                        out.println("<tr>");
                            out.println("<form action='modifica.jsp' method = 'post'>");
                                out.println("<td><input type = 'text' id = 'nome' name = 'nome' placeholder = '"+r3.getString(2)+"'></td>");
                                out.println("<td><input type = 'text' id = 'descrizione' name = 'descrizione' placeholder = '"+r3.getString(4)+"'></td>");
                                out.println("<td><input type = 'text' id = 'quantita' name = 'quantita' placeholder = '"+r3.getString(6)+"'></td>");
                                out.println("<td><input type = 'text' id = 'prezzo' name = 'prezzo' placeholder = '"+r3.getString(7)+"'></td>");
                                out.println("<input type='hidden' id='idProd' name='idProd' value = '"+idProd+"'>");
                                    
                                out.println("<td> <input type= 'submit' class = 'btn1' value= 'Salva'></td>");
                            out.println("</form>"); 
                            
                        out.println("</tr>");
                }
                out.println("</table>");
            }

            out.println("<br><p>Prodotti Venduti: </p><br>");
                //inseririre i prodotti acquistati dai clienti
            
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
            <input type="button" value="Home Proprietario"/> <br> 
        </a>

    </body>

</html>