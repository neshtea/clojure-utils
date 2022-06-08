(ns cljfmt-wrapped.core
  (:require [cljfmt.main :as cljfmt-main])
  (:gen-class))

(defn -main
  [& args]
  (apply cljfmt-main/-main args))
