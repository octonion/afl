select npl.parameter,npl.type,npl.level,nbf.estimate
from afl._parameter_levels npl
left outer join afl._basic_factors nbf
  on (nbf.factor,nbf.type)=(npl.parameter||npl.level,npl.type)
where npl.type='fixed'
order by parameter,level;
