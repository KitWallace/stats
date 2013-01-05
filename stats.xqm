module namespace stats = "http://kitwallace.me/stats";

declare function stats:mean($vals as xs:decimal*) as xs:decimal {
   sum($vals) div count($vals)
};

declare function stats:variance($vals as xs:decimal*) as xs:decimal  {
   let $mean := stats:mean($vals)
   return math:sqrt(sum(for $val in $vals return ($val - $mean)*($val - $mean)) div count($vals))
};

declare function stats:colnames ($data) {
   $data[1]/*/name(.)
};

declare function stats:remove-missing-values($data as element(row)*) as element(row) * {
   for $row in $data return element row {$row/*[not (. = "NA")]}
};

declare function stats:remove-missing-rows($data as element(row)*) as element(row) * {
   $data[not (* = "NA")]
};


declare function stats:summary($data as element(row)*, $cols as xs:string*){
 element summary {
   for $colname in $cols
   let $col := $data/*[name(.) = $colname]
   return
      element column {
         element name {$colname},
         element count {count($col)},    
         element missing {count($col[. = "NA"])},
         element valid {count($col[not(. = "NA")])},
         element mean {stats:mean($col[not (. = "NA")])},
         element min {min($col[not (. = "NA")])},
         element max {max($col[not (. = "NA")])},
         element variance {stats:variance($col[not (. = "NA")])}
      }
 }
};
