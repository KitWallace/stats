import module namespace stats = "http://kitwallace.me/stats" at "stats.xqm";

let $data := doc("/db/apps/r/data/hw1.xml")/table/row
let $colnames := stats:colnames($data)
let $clean := stats:remove-missing-values($data)
let $fullcases := stats:remove-missing-rows($data)

return

element results {
   element data {stats:summary($data,$colnames)},
   element clean {stats:summary($clean,$colnames)},
   element fullcases {count($fullcases)},

   element firstRows {$data[position() <= 2]},
   element lastrows {$data[position() >= count($data)-1]},
   element ozone47 {$data[47]/Ozone},
   element missingOzone {count($data[Ozone="NA"])},
   element meanOzone {stats:mean($clean/Ozone)},
   element meanSolar {stats:mean($clean[Ozone > 31 and Temp > 90]/Solar.R)},
   element meantemp6 {stats:mean($clean[Month=6]/Temp)},
   element vartemp6 {stats:variance($clean[Month=6]/Temp)}
}
