<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <tr>
				<th>번호</th>
				<th>작성자</th>
				<th>제목</th>
				<th>작성일</th>
				<th>결재일</th>
				<th>결재자</th>
				<th>결재상태</th>
			</tr>
			<c:forEach items="${approvalList }" var="approval" varStatus="status">
				<tr class="line" onClick="location.href='sign?loadSeq=${approval.seq }'">
					<td>${approval.seq }</td>
					<td>${approval.memName }</td>
					<td>${approval.subject }</td>
					<td>${approval.regDate }</td>
					<td>${approval.uptDate }</td>
					<td>${approval.appName }
						<c:if test="${not empty approval.proxyName }">
							<br>(${approval.proxyName })
						</c:if>
					</td>
					<td>${approval.state }</td>
				</tr>
			</c:forEach>