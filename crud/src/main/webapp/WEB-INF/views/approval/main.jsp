<%@page import="java.lang.ProcessBuilder.Redirect"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib prefix="c" uri = "http://java.sun.com/jsp/jstl/core" %>
    <%@ taglib prefix="fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<style type="text/css">
	#section {
		padding: 20px;
		width: 600px;
		margin: 0 auto;
	}
	#searchForm{
		display: flex;
	    flex-direction: column;
	    align-items: center;
	    justify-content: space-around;
	    height: 70px;
	    border: 1px solid;
	    margin: 10px 0;
	    
	}
	#optionTable{
		width: 100%;
		text-align: center;
	}
	.line:hover{
		background: lightgray;
		cursor: pointer;
	}
	.modal{ 
	  	position:absolute; 
	  	width:100%; height:100%; 
	 	background: rgba(0,0,0,0.8); 
	 	top:0; left:0; 
	  	display:none;
	}
	.modal_content{
	 	width:400px; height:200px;
		background: skyblue; border-radius:10px;
		position:relative; top:50%; left:50%;
	  	margin-top:-100px; margin-left:-200px;
	  	text-align:center;
	  	box-sizing:border-box; padding:30px 0;
	  	line-height:23px;
	}
	.labels{
		width: 100px;
	}
	.rowCol{
		display: flex;
		text-align: left;
		margin: 10px 0;
		padding-left: 50px;
	}
</style>
<script type="text/javascript">
	$(function() {
		// 검색 폼 세팅
		if('${search.sel}' == null || '${search.sel}' == ""){
			$("#sel").val("none");
		} else {
			$("#sel").val('${search.sel}');
		}
		
		if('${search.STATE}' == null || '${search.STATE}' == ""){
			$("#STATE").val("none");
		} else {
			$("#STATE").val('${search.STATE}');	
		}
		
		// 글쓰기 버튼
		$("#writeBtn").click(function() {
			location.href="sign";
		});
		
		// 로그아웃 버튼
		$("#logoutBtn").click(function() {
			location.href="logout";
		});
		
		// 옵션:상태 변경
		$("#STATE").change(function() {
			$.ajax({
	            url: "main/option",
	            type: "get",	
	            data: $("#searchForm").serialize(),
	            success: function(data){
	            	$("#optionTable").html(data);
	            },
	            error: function(data){
	                alert(data);
	            }
	        });
		});
		
		// 검색 버튼
		$("#searchBtn").click(function() {
			$("#searchForm").attr("action","main").attr("method","get").submit();
		});
		
		// 대리결재 버튼
		$("#proxyBtn").click(function(){
			if("${sessionScope.memRank}" == 'employee'){
        		$("#memName").val("${sessionScope.memName}(사원)");
        	} else if("${sessionScope.memRank}" == 'assistant'){
        		$("#memName").val("${sessionScope.memName}(대리)");
        	} else if("${sessionScope.memRank}" == 'manager'){
        		$("#memName").val("${sessionScope.memName}(과장)");
        	} else if("${sessionScope.memRank}" == 'general'){
        		$("#memName").val("${sessionScope.memName}(부장)");
        	}
		    $(".modal").fadeIn();
		    $.ajax({
	            url: "main/proxy",
	            type: "get",	
	            data: $("#modalForm").serialize(),
	            success: function(data){
	            	$("#proxyList").empty();
	            	$("#proxyList").append('<option value="none">선택</option>');
	            	$.each(data, function(index, proxy){
	            		$("#proxyList").append('<option value="' + proxy.memNo + '">"' + proxy.memName + '"</option>');
	    		    });
	            },
	            error: function(data){
	                alert(data);
	            }
	        });
		  });
		
		// 대리결재창 취소
		$("#cancelModal").click(function(){
			$("#memRank").val("");
		    $(".modal").fadeOut();
		});
		
		// 대리결재자 선택 시
		$("#proxyList").change(function() {
			if($("#proxyList").val() == "none"){
				$("#memRank").val("");
			} else {
				$.ajax({
		            url: "main/proxySet",
		            type: "get",	
		            data: $("#modalForm").serialize(),
		            success: function(data){
		            	if(data.memRank == 'employee'){
		            		$("#memRank").val("사원");
		            	} else if(data.memRank == 'assistant'){
		            		$("#memRank").val("대리");
		            	} else if(data.memRank == 'manager'){
		            		$("#memRank").val("과장");
		            	} else if(data.memRank == 'general'){
		            		$("#memRank").val("부장");
		            	}
		            	$("#memNo").val(data.memNo);
		            },
		            error: function(data){
		                alert(data);
		            }
		        });
			}
		});
		
		// 대리결재 승인 버튼
		$("#proxyApply").click(function() {
			alert("대리결재 신청이 완료되었습니다.");
			$("#modalForm").attr("action","proxy/apply").attr("method","post").submit();
		});
	})
</script>
<title>Insert title here</title>
</head>
<body>
<div id="section">
<%-- 	<c:if test="${empty memName }">
		<c:redirect url="login"></c:redirect>
	</c:if> --%>
	<div>
		${memName }
		<c:choose>
			<c:when test="${memRank eq 'employee'}">(사원)</c:when>
			<c:when test="${memRank eq 'assistant'}">(대리)</c:when>
			<c:when test="${memRank eq 'manager'}">(과장)</c:when>
			<c:when test="${memRank eq 'general'}">(부장)</c:when>
		</c:choose>
		<c:if test="${not empty sessionScope.proxyName }">
			- ${sessionScope.proxyName }
			<c:choose>
				<c:when test="${sessionScope.proxyRank eq 'employee'}">(사원)</c:when>
				<c:when test="${sessionScope.proxyRank eq 'assistant'}">(대리)</c:when>
				<c:when test="${sessionScope.proxyRank eq 'manager'}">(과장)</c:when>
				<c:when test="${sessionScope.proxyRank eq 'general'}">(부장)</c:when>
			</c:choose>
		</c:if> 
		님 환영합니다. <button id="logoutBtn">로그아웃</button><br>
		<c:if test="${not empty sessionScope.proxyName }">
			(대리결재일 : ${sessionScope.proxyTime } ~ ${sessionScope.proxyEnd })
		</c:if>
		
	</div>
	<div align="right">
		<button id="writeBtn">글쓰기</button>
		<c:if test="${'manager' eq memRank or 'general' eq memRank }">
			<button id="proxyBtn">대리결재</button>
		</c:if>
	</div>
	
	<!-- 대리결재 창 -->
	<div class="modal">
		<div class="modal_content">
			<form id="modalForm">
				<div class="rowCol">
					<div class="labels">대리결재자 : </div>
					<select name="proxyList" id="proxyList"></select>
				</div>
				<div class="rowCol">
					<div class="labels">직급 : </div>
					<input type="text" name="memRank" id="memRank" placeholder="직급" readonly="readonly">
				</div>
				<div class="rowCol">
					<div class="labels">대리자 : </div>
					<input type="text" name="memName" id="memName" placeholder="대리자 이름(직급)" readonly="readonly">
					<input type="hidden" name="memNo" id="memNo">
				</div>
			</form>
			<button id="cancelModal">취소</button>
			<button id="proxyApply">승인</button>
		</div>
	</div>
	
	<div>
		<form id="searchForm">
			<div>
				<select name="sel" id="sel">
					<option value="none">선택</option>
					<option value="MEM_NAME">작성자</option>
					<option value="SUBJECT">제목</option>
					<option value="APP_NAME">결재자</option>
					<option value="SUBJECT||CONTENT">제목+내용</option>
				</select>
				<input type="text" name="selText" id="selText" placeholder="검색어를 입력하세요" value="${search.selText }">
				<select name="STATE" id="STATE">
					<option value="none">결재상태</option>
					<option value="temporary">임시저장</option>
					<option value="wait">결재대기</option>
					<option value="decide">결재중</option>
					<option value="complete">결재완료</option>
					<option value="refuse">반려</option> 
				</select>
			</div>
			<div>
				<!-- <input type="datetime-local" id="stDate" name="stDate" value="${search.stDate }"> -->
				<input type="date" id="stDate" name="stDate" value="${search.stDate }">
				~
				<!-- <input type="datetime-local" id="endDate" name="endDate" value="${search.endDate }"> -->
				<input type="date" id="endDate" name="endDate" value="${search.endDate }">
				<button id="searchBtn">검색</button>
			</div>
		</form>
	</div>
	<br>
	<div>
		<table border="1" id="optionTable">
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
		</table>
	</div>
</div>
</body>
</html>