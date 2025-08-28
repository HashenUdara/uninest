<%@ page contentType="text/html;charset=UTF-8" %>
<html>
  <head>
    <title>Add Student</title>
  </head>
  <body>
    <h1>Add Student</h1>
    <form
      method="post"
      action="${pageContext.request.contextPath}/students/add"
    >
      <label>Name: <input name="name" /></label><br />
      <label>Email: <input name="email" type="email" /></label><br />
      <button type="submit">Save</button>
    </form>
    <a href="${pageContext.request.contextPath}/students">Back</a>
  </body>
</html>
