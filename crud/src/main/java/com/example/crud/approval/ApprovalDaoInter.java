package com.example.crud.approval;

import java.util.List;
import java.util.Map;

public interface ApprovalDaoInter{

	Map<String, Object> login(Map<String, Object> paramMap);

	int highSeq();

//	List<Map<String, Object>> listApproval(String memNo);

	void signApproval(Map<String, Object> paramMap);

	Map<String, Object> detailApproval(String loadSeq);

	List<Map<String, Object>> history(String loadSeq);

	List<Map<String, Object>> optApproval(Map<String, Object> paramMap);

	List<Map<String, Object>> proxy(String memRank);

	Map<String, Object> proxySet(int memNo);

	void proxyApply(Map<String, Object> paramMap);

	void proxyCheck(String local);

}
