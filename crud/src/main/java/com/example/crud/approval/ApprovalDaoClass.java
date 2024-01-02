package com.example.crud.approval;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.support.DaoSupport;
import org.springframework.stereotype.Repository;

@Repository("daoApproval")
public class ApprovalDaoClass implements ApprovalDaoInter{
	@Autowired
	SqlSession sqlSession;
	
	DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss.S");

	@Override
	public Map<String, Object> login(Map<String, Object> paramMap) {
		// TODO Auto-generated method stub
		return sqlSession.selectOne("mapper.login", paramMap);
	}

	@Override
	public int highSeq() {
		// TODO Auto-generated method stub
		if(sqlSession.selectOne("mapper.highSeq") == null) {
			return 1;
		} else {
			return sqlSession.selectOne("mapper.highSeq");
		}
	}

//	@Override
//	public List<Map<String, Object>> listApproval(String memNo) {
//		// TODO Auto-generated method stub
//		Map<String, Object> paramMap = sqlSession.selectOne("mapper.memInfo", memNo);
//		sqlSession.selectList("mapper.memInfo", paramMap);
//		List<Integer> list = sqlSession.selectList("mapper.getSeqs", paramMap);
//		return sqlSession.selectList("mapper.listApproval", list);
//	}

	@Override
	public void signApproval(Map<String, Object> paramMap) {
		// TODO Auto-generated method stub
		// 결재 생성 또는 변경
		if(sqlSession.selectOne("mapper.detailApproval", paramMap.get("seq")) == null) {
			sqlSession.insert("mapper.signApproval", paramMap);
		} else {
			sqlSession.update("mapper.updateApp", paramMap);
		}
		
		// history 번호 생성
		int hisSeq;
		if(sqlSession.selectOne("mapper.highHis") == null) {
			hisSeq = 1;
		}else {
			hisSeq = sqlSession.selectOne("mapper.highHis");
		}	
		paramMap.put("hisSeq", hisSeq);
		// history use 변경
		String state = sqlSession.selectOne("mapper.hisState", paramMap);
		sqlSession.update("mapper.hisUse", paramMap);
		// 이전 기록이 반려일 경우
		if(state != null && state.equals("refuse")) {
			sqlSession.update("mapper.hisRefuse", paramMap);
		}
		// history 생성
		sqlSession.insert("mapper.history", paramMap);
	}

	@Override
	public Map<String, Object> detailApproval(String loadSeq) {
		// TODO Auto-generated method stub
		return sqlSession.selectOne("mapper.detailApproval", loadSeq);
	}

	@Override
	public List<Map<String, Object>> history(String loadSeq) {
		// TODO Auto-generated method stub
		return sqlSession.selectList("mapper.hisList", loadSeq);
	}

	@Override
	public List<Map<String, Object>> optApproval(Map<String, Object> paramMap) {
		// TODO Auto-generated method stub
		// 아이디와 일치하는 회원정보
		String memNo = paramMap.get("memNo").toString();
		Map<String, Object> memInfo = sqlSession.selectOne("mapper.memInfo", memNo);
		paramMap.putAll(memInfo);
		// 대리결제 권한이 있으면
		if(memInfo.get("proxyTime") != null) {
			LocalDateTime proxyTime = LocalDateTime.parse(memInfo.get("proxyTime").toString(), formatter);
			paramMap.replace("proxyTime", proxyTime.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")));
		}
		List<Integer> list = sqlSession.selectList("mapper.getSeqs", paramMap);
		paramMap.put("list", list);
		return sqlSession.selectList("mapper.listApproval", paramMap);
	}
	
	// 대리결재자 목록
	@Override
	public List<Map<String, Object>> proxy(String memRank) {
		// TODO Auto-generated method stub
		return sqlSession.selectList("mapper.proxy", memRank);
	}

	@Override
	public Map<String, Object> proxySet(int memNo) {
		// TODO Auto-generated method stub
		return sqlSession.selectOne("mapper.proxySet", memNo);
	}

	@Override
	public void proxyApply(Map<String, Object> paramMap) {
		// TODO Auto-generated method stub
		sqlSession.update("mapper.proxyApply", paramMap);
	}

	@Override
	public void proxyCheck(String local) {
		// TODO Auto-generated method stub
		sqlSession.update("mapper.proxyCheck", local);
	}

}
