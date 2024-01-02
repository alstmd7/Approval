<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib prefix="c" uri = "http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<style type="text/css">
	#sectionSign{	
		display: flex;
	    flex-direction: column;
	    align-items: center;
	    padding: 20px;
	    width: 400px;
	    margin: 0 auto;
	}
	#tableHis{
		width: 100%;
		text-align: center;
	}
	#tableChk{
		width: 80%;
    	text-align: center;
    	margin-bottom: 20px;
	}
	#tableChk th{
		width: 33.3%;
	}
	#signForm{
		width: 60%;
		margin: 0 auto;
	}
	.infoLine{
		display: flex;
	    justify-content: space-between;
	    margin: 5px 0;
	}
	.infoName{
		width: 70px;
	}
	textarea{
		width: 100%;
	    margin: 5px 0;
	    height: 60px;
	}
</style>
<script type="text/javascript">
	$(function() {
		// 결재 진행사항 체크박스
		if("${detail.state}" == "wait"){
			$('#waitChk').prop('checked',true);
		}
		if("${detail.state}" == "decide"){
			$('#waitChk').prop('checked',true);
			$('#decChk').prop('checked',true);
		}
		if("${detail.state}" == "complete"){
			$('#waitChk').prop('checked',true);
			$('#decChk').prop('checked',true);
			$('#comChk').prop('checked',true);
		}
		
		// 임시저장버튼 비활성화
		if($('#waitChk').is(':checked')){
			$("#temporaryBtn").hide();
		}
		
		// 결재버튼 비활성화
		if($('#comChk').is(':checked')){
			$("#decideBtn").hide();
		}
		// 결재단계 : 결재 중
		if($('#decChk').is(':checked')){
			// 계급 : 부장
			if("${memRank}" == "general" || "${proxyRank}" == "general"){
			} else {
				$("#decideBtn").hide();
			}
		// 결재단계 : 결재 요청
		} else if($('#waitChk').is(':checked')){
			// 계급 : 과장
			if("${memRank}" == "manager" || "${proxyRank}" == "manager"){
			} else {
				$("#decideBtn").hide();
			}
			// 결재단계 : 반려
		} else if("${detail.state}" == "refuse"){
			if("${detail.memNo}" != "${sessionScope.memNo}"){
				$("#decideBtn").hide();
			}
		}
		
		// 반려버튼 비활성화
		if($('#comChk').is(':checked')){
			$("#refuseBtn").hide();
		}
		// 결재단계 : 결재 중
		if($('#decChk').is(':checked')){
			// 계급 확인 : 부장
			if("${memRank}" != "general" && "${proxyRank}" != "general"){
				$("#refuseBtn").hide();
			}
		// 결재단계 : 결재 대기
		} else if($('#waitChk').is(':checked')){
			// 계급확인 : 과장
			if("${memRank}" == "manager" || "${proxyRank}" == "manager"){
			} else {
				$("#refuseBtn").hide();
			}
		// 결재단계 : 반려
		} else if("${detail.state}" == "refuse"){
			if("${detail.memNo}" != "${sessionScope.memNo}"){
				$("#refuseBtn").hide();
			}
		}
		
		// 임시저장 버튼
		$("#temporaryBtn").click(function() {
			if($("#subject").val() == ""){
				alert("제목을 입력해주세요.");
				return false;
			}
			if($("#content").val() == ""){
				alert("내용을 입력해주세요.");
				return false;
			}
			alert("임시저장이 완료되었습니다.");
			$("#signForm").attr("action","sign/accept").attr("method","post").submit();
		});
		
		// 결재 버튼
		$("#decideBtn").click(function() {
			// 제목 내용 확인
			if($("#subject").val() == ""){
				alert("제목을 입력해주세요.");
				return false;
			}
			if($("#content").val() == ""){
				alert("내용을 입력해주세요.");
				return false;
			}
			// 결재단계 : 결재 중
			if($('#decChk').is(':checked')){
				// 계급 : 부장
				if("${memRank}" == "general" || "${proxyRank}" == "general"){
					$("#state").val("complete");
				}
			// 결재단계 : 결재 요청
			} else if($('#waitChk').is(':checked')){
				// 계급 : 과장
				if("${memRank}" == "manager" || "${proxyRank}" == "manager"){
					$("#state").val("decide");
					// 대리계급 : 부장
					if("${proxyRank}" == "general"){
						$("#state").val("complete");
					}
				}
			// 결재단계 : 나머지
			} else {
				// 계급확인 : 부장
				if("${memRank}" == "general" || "${proxyRank}" == "general"){
					$("#state").val("complete");
				// 계급확인 : 과장
				} else if ("${memRank}" == "manager" || "${proxyRank}" == "manager") {
					$("#state").val("decide");
				// 계급확인 : 나머지
				} else {
					$("#state").val("wait");
				}
			}
			alert("결재가 완료되었습니다.");
			$("#signForm").attr("action","sign/decide").attr("method","post").submit();
		});
		
		// 반려 버튼
		$("#refuseBtn").click(function() {
			// 결재단계 : 결재 중
			if($('#decChk').is(':checked')){
				// 계급 확인 : 부장
				if("${memRank}" == "general" || "${proxyRank}" == "general"){
					$("#state").val("refuse");
				}
			// 결재단계 : 결재 대기
			} else if($('#waitChk').is(':checked')){
				// 계급확인 : 과장
				if("${memRank}" == "manager" || "${proxyRank}" == "manager"){
					$("#state").val("refuse");
				}
			}
			alert("반려가 완료되었습니다.");
			$("#signForm").attr("action","sign/decide").attr("method","post").submit();
		});
	});
</script>
<title>Insert title here</title>
</head>
<body>
<div id="sectionSign">
 	<c:if test="${empty memName }">
		<c:redirect url="login"></c:redirect>
	</c:if>
		<table border="1" id="tableChk">
			<tr>
				<th>결재요청</th>
				<th>과장</th>
				<th>부장</th>
			</tr>
			<tr>
				<td><input type="checkbox" id="waitChk" disabled="disabled">
				</td>
				<td><input type="checkbox" id="decChk" disabled="disabled">
				</td>
				<td><input type="checkbox" id="comChk" disabled="disabled">
				</td>
			</tr>
		</table>
	<form id="signForm">
		<c:choose>
			<c:when test="${empty detail }">
					<div class="infoLine"><span class="infoName">번호 : </span><input type="text" name="seq" id="seq" value="${seq }" readonly="readonly"></div>
					<div class="infoLine"><span class="infoName">작성자 : </span><input type="text" name="memName" id="memName" value="${memName }" readonly="readonly"></div>	
					<div class="infoLine"><span class="infoName">제목 : </span><input type="text" name="subject" id="subject"></div>
					<span class="infoName">내용 : </span><br>
					<textarea name="content" id="content"></textarea><br>
					<input type="hidden" name="state" id="state" value="${detail.state }">
			</c:when>
			<c:when test="${(detail.memNo eq sessionScope.memNo) && (detail.state eq 'temporary' || detail.state eq 'refuse')}">
					<div class="infoLine"><span class="infoName">번호 : </span><input type="text" name="seq" id="seq" value="${detail.seq }" readonly="readonly"></div>
					<div class="infoLine"><span class="infoName">작성자 : </span><input type="text" name="memName" id="memName" value="${detail.memName }" readonly="readonly"></div>	
					<div class="infoLine"><span class="infoName">제목 : </span><input type="text" name="subject" id="subject" value="${detail.subject }"></div>
					<span class="infoName">내용 : </span><br>
					<textarea name="content" id="content">${detail.content }</textarea><br>
					<input type="hidden" name="state" id="state" value="${detail.state }">
			</c:when>
			<c:otherwise>
					<div class="infoLine"><span class="infoName">번호 : </span><input type="text" name="seq" id="seq" value="${detail.seq }" readonly="readonly"></div>
					<div class="infoLine"><span class="infoName">작성자 : </span><input type="text" name="memName" id="memName" value="${detail.memName }" readonly="readonly"></div>	
					<div class="infoLine"><span class="infoName">제목 : </span><input type="text" name="subject" id="subject" value="${detail.subject }" readonly="readonly"></div>
					<span class="infoName">내용 : </span><br>
					<textarea name="content" id="content" readonly="readonly">${detail.content }</textarea><br>
					<input type="hidden" name="state" id="state" value="${detail.state }">
			</c:otherwise>
		</c:choose>
	</form>
	<div>
		<c:if test="${not empty detail }">
			<c:if test="${detail.memNo ne memNo }">
				<button id="refuseBtn">반려</button>
			</c:if>
		</c:if>
		<c:choose>
			<c:when test="${empty detail }">
				<button id="temporaryBtn">임시저장</button>
			</c:when>
			<c:otherwise>
				<c:if test="${detail.memNo eq memNo }">
					<button id="temporaryBtn">임시저장</button>
				</c:if>
			</c:otherwise>
		</c:choose>
		<button id="decideBtn">결재</button>
	</div>
	<br>
		<table border="1" id="tableHis">
				<tr>
					<th>번호</th>
					<th>결재일</th>
					<th>결재자</th>
					<th>결재상태</th>
				</tr>
				<c:if test="${not empty detail}">
				<c:forEach items="${hisList }" var="his" varStatus="status">
					<tr>
						<td>${status.count}</td>
						<td>
							<c:choose>
								<c:when test="${empty his.uptDate }">
									${his.regDate}
								</c:when>
								<c:otherwise>
									${his.uptDate}
								</c:otherwise>
							</c:choose>
						</td>
						<td>
							<c:choose>
								<c:when test="${empty his.memName }">
									${his.wriName}
								</c:when>
								<c:otherwise>
									${his.memName}<c:if test="${not empty his.proxyName }">(${his.proxyName })</c:if>
								</c:otherwise>
							</c:choose>
						</td>
						<td>${his.state }</td>
					</tr>
				</c:forEach>
				</c:if>
			</table>
	</div>
</body>
</html>