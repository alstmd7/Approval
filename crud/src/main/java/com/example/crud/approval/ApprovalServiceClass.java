package com.example.crud.approval;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service("serviceApproval")
public class ApprovalServiceClass implements ApprovalServiceInter{
	@Autowired
	ApprovalDaoInter daoApproval;

	@Override
	public Map<String, Object> login(Map<String, Object> paramMap) {
		// TODO Auto-generated method stub
		return daoApproval.login(paramMap);
	}

	@Override
	public int highSeq() {
		// TODO Auto-generated method stub
		return daoApproval.highSeq();
	}

//	@Override
//	public List<Map<String, Object>> listApproval(String memNo) {
//		// TODO Auto-generated method stub
//		return daoApproval.listApproval(memNo);
//	}

	@Override
	public void signApproval(Map<String, Object> paramMap) {
		// TODO Auto-generated method stub
		daoApproval.signApproval(paramMap);
	}

	@Override
	public Map<String, Object> detailApproval(String loadSeq) {
		// TODO Auto-generated method stub
		return daoApproval.detailApproval(loadSeq);
	}

	@Override
	public List<Map<String, Object>> history(String loadSeq) {
		// TODO Auto-generated method stub
		return daoApproval.history(loadSeq);
	}

	@Override
	public List<Map<String, Object>> optApproval(Map<String, Object> paramMap) {
		// TODO Auto-generated method stub
		return daoApproval.optApproval(paramMap);
	}

	@Override
	public List<Map<String, Object>> proxy(String memRank) {
		// TODO Auto-generated method stub
		return daoApproval.proxy(memRank);
	}

	@Override
	public Map<String, Object> proxySet(int memNo) {
		// TODO Auto-generated method stub
		return daoApproval.proxySet(memNo);
	}

	@Override
	public void proxyApply(Map<String, Object> paramMap) {
		// TODO Auto-generated method stub
		daoApproval.proxyApply(paramMap);
	}

	@Override
	public void proxyCheck(String local) {
		// TODO Auto-generated method stub
		daoApproval.proxyCheck(local);
	}

}
