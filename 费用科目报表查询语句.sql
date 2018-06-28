select t1.公司,t1.年度,t1.月份,t1.科目编码,t1.科目名称,t1.金额,t1.费用类别 from 
(SELECT
       orgs.name 公司, 
       b.yearv||'年' 年度,
       b.periodv||'月' 月份,
       substr(c.code, 1, 6) 科目编码,
  t.科目名称 科目名称,   
  t.费用类别,   
       sum(b.localdebitamount) 金额
       
FROM gl_detail b
left join bd_accasoa ac on b.pk_accasoa = ac.pk_accasoa
left join bd_account c on ac.pk_account = c.pk_account
left join org_orgs orgs on b.pk_org = orgs.pk_org
left join (SELECT c.code 科目编码,ac.name 科目名称,
    decode(substr(c.code, 1, 4),'6601','销售费用','6602','管理费用','6603','财务费用') 费用类别       
    FROM bd_accasoa ac 
    left join bd_account c on ac.pk_account = c.pk_account
    where substr(c.code,1,2) = '66')t on substr(c.code, 1, 6) = t.科目编码

WHERE b.dr = 0 and c.code like '66%'  and b.periodv <> '00' 
${if(len(年度) == 0,"and 1 = 1","and b.yearv = '" + 年度 + "'")}
group by orgs.name,b.yearv,b.periodv,substr(c.code, 1, 6),t.科目名称,t.费用类别
)t1
order by t1.科目编码
