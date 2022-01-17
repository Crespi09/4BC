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
            Quantita': <input type= "text" id = "quantita" name = "quantita" placeholder = "Quantita'" required>
            Prezzo: <input type= "text" id = "prezzo" name = "prezzo" placeholder = "Prezzo" required>

            <input type = "submit" id = "btn" name = "btn" value = "Aggiungi Prodotto" onclick ="Aggiungi()">        
        </form>

        <%
        String usr = (String) request.getSession().getAttribute("username");

        String DRIVER = "net.ucanaccess.jdbc.UcanaccessDriver";
        
        String nome = null;
        String descrizione = null;
        String quantita = null;
        String prezzo = null;

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

            connection = DriverManager.getConnection("jdbc:ucanaccess://" + request.getServletContext().getRealPath("/") + "DatiUtenti.accdb");
            //query controllo se un prodotto è già stato inserito dallo stesso proprietario
            String query = "SELECT * FROM Prodotti WHERE proprietario = '"+usr+"';";
            String queryControllo = "SELECT nome,proprietario FROM Prodotti WHERE nome = '"+nome+"' AND proprietario = '"+usr+"';";
            String queryInserimento = "INSERT INTO Prodotti(nome,descrizione,quantita,prezzo,proprietario) VALUES ('"+nome+"' , '"+descrizione+"' , '"+quantita+"' , '"+prezzo+"' , '"+usr+"')";

            Statement st = connection.createStatement();
            ResultSet r1 = st.executeQuery(queryControllo);
            ResultSet r3 = st.executeQuery(query);


            if((nome != null) || (descrizione != null) || (quantita != null) || (prezzo != null)){
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
            out.println("<table>");

                out.println("<tr>");
                    out.println("<th>Nome</th>");
                    out.println("<th>Descrizione</th>");
                    out.println("<th>Quantita'</th>");
                    out.println("<th>Prezzo</th>");
                out.println("</tr>");
                
                while(r3.next()){   
                     String idProd = r3.getString(1); 
                     System.out.println("id:"+idProd);
                        out.println("<tr>");
                            out.println("<td>"+r3.getString(2)+ "</td>");
                            out.println("<td>"+r3.getString(5)+ "</td>");
                            out.println("<td>"+r3.getString(3)+ "</td>");
                            out.println("<td>"+r3.getString(4)+ "</td>");

                            //modifica
                            out.println("<form action='modifica.jsp' method='POST'>");
                                //out.println("<input type='hidden' id='idProd' name='idProd' value = '"+idProd+"'>");
                                out.println("<td> <input type= 'submit' class = 'btn1' value= 'Modifica'></td>");
                            out.println("</form>");
                            
                            //elimina
                            out.println("<form action='elimina.jsp' method='POST'>");
                                out.println("<input type='hidden' id='idProd' name='idProd' value = '"+idProd+"'>");
                                out.println("<td> <input type= 'submit' class = 'btn1' value= 'Elimina'></td>");
                            out.println("</form>");

                        out.println("</tr>");
                }
            out.println("</table>");

            out.println("<br><p>Prodotti Venduti: </p><br>");
            
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
            <input type="button" value="Indietro"/> <br> 
        </a>

    </body>

</html>