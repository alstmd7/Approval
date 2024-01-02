package com.example.crud.approval;

import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class ApprovalController {
	SimpleDateFormat fmt = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
	DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss.S");
	
	@Autowired
	public ApprovalServiceInter serviceApproval;
	
	@RequestMapping("login")
	public String login() {
		return "approval/login";
	}
	
	// 로그인 버튼
	@RequestMapping("login/check")
	@ResponseBody
	public String loginCheck(@RequestParam Map<String, Object> paramMap, HttpServletRequest request) {
		String result = "fail";
		Map<String, Object> memInfo = new HashMap<String, Object>(); 
		// 대리결재 권한 갱신
		LocalDateTime local = LocalDateTime.now();
		serviceApproval.proxyCheck(local.minusHours(6).format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")));
		memInfo = serviceApproval.login(paramMap);
		// 아이디 오류 시
		if (memInfo == null) {
			result = "idFail";
		// 비밀번호 오류 시
		} else {
			if(memInfo.get("memPw").equals(paramMap.get("memPw"))) {
				result = "success";
				HttpSession httpSession = request.getSession();
				httpSession.setAttribute("memNo", memInfo.get("memNo"));
				httpSession.setAttribute("memName", memInfo.get("memName"));
				httpSession.setAttribute("memRank", memInfo.get("memRank"));
				httpSession.setAttribute("proxyNo", memInfo.get("proxyNo"));
				httpSession.setAttribute("proxyName", memInfo.get("proxyName"));
				if(memInfo.get("proxyTime") != null) {
					LocalDateTime proxyTime = LocalDateTime.parse(memInfo.get("proxyTime").toString(), formatter);
					httpSession.setAttribute("proxyTime", proxyTime.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")));
					httpSession.setAttribute("proxyEnd", proxyTime.plusHours(6).format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")));
				}
				httpSession.setAttribute("proxyRank", memInfo.get("proxyRank"));
			} else {
				result = "pwFail";
			}
		}
		return result;
	}

//	@RequestMapping("main")
//	public String main(Model model, HttpServletRequest request) {
//		List<Map<String, Object>> list = new ArrayList<Map<String,Object>>();
//		HttpSession httpSession = request.getSession();
//		if(httpSession.getAttribute("memNo") == null) {
//			return "redirect:/login";
//		}
//		String memNo = httpSession.getAttribute("memNo").toString();
//		list = serviceApproval.listApproval(memNo);
//		model.addAttribute("approvalList", list);
//		return "approval/main";
//	}
	
	// 문서쓰기 및 문서정보
	@RequestMapping("sign")
	public String approval(Model model, @RequestParam(required = false) String loadSeq) {
		if(loadSeq == null) {
			int seq = serviceApproval.highSeq();
			model.addAttribute("seq", seq);
		} else {
			Map<String, Object> detail = serviceApproval.detailApproval(loadSeq);
			List<Map<String, Object>> hisList = serviceApproval.history(loadSeq);
			model.addAttribute("detail", detail);
			model.addAttribute("hisList", hisList);
		}		
		return "approval/sign";
	}
	
	// 임시저장 버튼
	@RequestMapping("sign/accept")
	public String accept(@RequestParam Map<String, Object> paramMap, HttpServletRequest request) {
		HttpSession httpSession = request.getSession();
		String memNo = httpSession.getAttribute("memNo").toString();
		paramMap.put("memNo", memNo);
		paramMap.put("state", "temporary");
		LocalDateTime local = LocalDateTime.now();
		paramMap.put("regDate", local.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")));
		serviceApproval.signApproval(paramMap);
		return "redirect:/main";
	}
	
	// 로그아웃 버튼
	@RequestMapping("logout")
	public String logout(HttpServletRequest request) {
		HttpSession httpSession = request.getSession();
		httpSession.invalidate();
		return "redirect:/login";
	}
	
	// 결재 버튼
	@RequestMapping("sign/decide")
	public String decide(@RequestParam Map<String, Object> paramMap, HttpServletRequest request) {
		HttpSession httpSession = request.getSession();
		String memNo = httpSession.getAttribute("memNo").toString();
		paramMap.put("memNo", memNo);
		LocalDateTime local = LocalDateTime.now();
		paramMap.put("regDate", local.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")));
		String state = paramMap.get("state").toString();
		// 업데이트날짜 추가
		if(state.equals("decide") || state.equals("complete") || state.equals("refuse")) {
			paramMap.put("appNo", memNo);
			paramMap.put("uptDate", local.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")));
			if(httpSession.getAttribute("proxyNo") != null) {
				int proxyNo = Integer.parseInt(httpSession.getAttribute("proxyNo").toString());
				if(proxyNo != 0) {
					paramMap.put("proxyNo", proxyNo);
				}
			}
		}
		serviceApproval.signApproval(paramMap);
		return "redirect:/main";
	}
	
	// 메인 비동기 검색
	@RequestMapping("main/option")
	public String option(@RequestParam Map<String, Object> paramMap, Model model, HttpServletRequest request) {
		List<Map<String, Object>> list = new ArrayList<Map<String,Object>>();
		HttpSession httpSession = request.getSession();
		// 로그인 정보 없을 시
		if(httpSession.getAttribute("memNo") == null) {
			return "redirect:/login";
		}
		String memNo = httpSession.getAttribute("memNo").toString();
		paramMap.put("memNo", memNo);
//		// datetime-local 형 변환
//		if(paramMap.get("stDate") != null && paramMap.get("endDate") != null 
//				&& paramMap.get("stDate") != "" && paramMap.get("endDate") != "") {
//			String[] st = paramMap.get("stDate").toString().split("T");
//			String stDate = st[0] + " " + st[1];
//			paramMap.replace("stDate", stDate);
//			String[] end = paramMap.get("endDate").toString().split("T");
//			String endDate = end[0] + " " + end[1];
//			paramMap.replace("endDate", endDate);
//		}
		list = serviceApproval.optApproval(paramMap);
		model.addAttribute("approvalList", list);
		return "approval/option";
	}
	
	// 메인
	@RequestMapping("main")
	public String search(@RequestParam Map<String, Object> paramMap, Model model, HttpServletRequest request) {
		List<Map<String, Object>> list = new ArrayList<Map<String,Object>>();
		HttpSession httpSession = request.getSession();
		// 로그인 정보 없을 시
		if(httpSession.getAttribute("memNo") == null) {
			return "redirect:/login";
		}
		String memNo = httpSession.getAttribute("memNo").toString();
		paramMap.put("memNo", memNo);
//		// datetime-local 형 변환
//		if(paramMap.get("stDate") != null && paramMap.get("endDate") != null 
//				&& paramMap.get("stDate") != "" && paramMap.get("endDate") != "") {
//			String[] st = paramMap.get("stDate").toString().split("T");
//			String stDate = st[0] + " " + st[1];
//			paramMap.replace("stDate", stDate);
//			String[] end = paramMap.get("endDate").toString().split("T");
//			String endDate = end[0] + " " + end[1];
//			paramMap.replace("endDate", endDate);
//		}
		// 검색 조건에 맞는 리스트 호출
		list = serviceApproval.optApproval(paramMap);
		model.addAttribute("approvalList", list);
		model.addAttribute("search", paramMap);
		return "approval/main";
	}
	
	// 대리결재자 목록
	@RequestMapping("main/proxy")
	@ResponseBody
	public List<Map<String, Object>> proxy(HttpServletRequest request){
		HttpSession httpSession = request.getSession();
		String memRank = httpSession.getAttribute("memRank").toString();
		List<Map<String, Object>> list = serviceApproval.proxy(memRank);
		return list;
	}
	
	// 대리결재자 선택
	@RequestMapping("main/proxySet")
	@ResponseBody
	public Map<String, Object> proxySet(@RequestParam Map<String, Object> paramMap){
		int memNo = Integer.parseInt(paramMap.get("proxyList").toString());
		Map<String, Object> proxy = serviceApproval.proxySet(memNo);
		return proxy;
	}
	
	// 대리결재권한 부여
	@RequestMapping("proxy/apply")
	public String proxyApply(@RequestParam Map<String, Object> paramMap, HttpServletRequest request) {
		HttpSession httpSession = request.getSession();
		paramMap.put("proxyNo", httpSession.getAttribute("memNo").toString());
		LocalDateTime local = LocalDateTime.now();
		paramMap.put("proxyTime", local.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")));
		serviceApproval.proxyApply(paramMap);
		return "redirect:/main";
	}
}
