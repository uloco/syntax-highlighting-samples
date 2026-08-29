;; Clojure highlight sample
; single semicolon comment
(ns demo.core
  "Namespace docstring."
  (:require [clojure.string :as str :refer [join blank?]]
            [clojure.set :refer :all])
  (:import (java.util Date UUID)
           java.io.File))

(def ^:const ^long limit 0xFF)
(def nums [1 1/3 10N 1.5M 2r1010 1e-5 -42])
(def ^{:doc "meta map" :added "1.0"} lookup
  {:a "x" ::ns-kw \newline \a 'quoted #{1 2} (list 1 2) nil true false 42})
(def state (atom {:hits 0}))

(defn- private-helper
  "Docstring with \"escapes\" and \t tab."
  [x & {:keys [scale] :or {scale 1.0} :as opts}]
  (* x scale))

(defmacro unless [pred & body]
  `(if ~pred nil (do ~@body)))

(defprotocol Shape
  (area [this])
  (scale [this factor]))

(defrecord Circle [r tag]
  Shape
  (area [_] (* Math/PI r r))
  (scale [this f] (update this :r * f)))

(deftype Box [^int w ^int h]
  Shape
  (area [_] (* w h)))

(defmulti render :kind)
(defmethod render :svg [{:keys [w h] :as m}] (str "<svg " w h ">"))
(defmethod render :default [_] nil)

(defn ^{:tag Long} process
  [items & more]
  (let [[first-item second-item & rest-items] items
        {:keys [id name] :or {name "anon"}} (meta items)
        re #"^\d{2,4}-(\w+)$"]
    (doseq [i (range 10) :when (odd? i)]
      (swap! state update :hits inc))
    (->> items
         (filter #(> % 2))
         (map (fn [x] (- x 1)))
         (reduce #(+ %1 %2) 0))
    (-> {:a 1} (assoc :b 2) keys sort)
    (as-> 5 v (+ v 1) (* v 2))
    (cond
      (blank? name) :empty
      (= id 1) :one
      :else (case (count items)
              0 :zero
              (1 2) :few
              :many))
    (condp re-matches "12-ab" re :>> second)
    (when (some? @state) (println (:hits @state) (join "," more)))
    (unless false
      (loop [n 0 acc []]
        (if (< n 3) (recur (inc n) (conj acc n)) acc)))
    (for [x [1 2] y [3 4] :when (not= x y)] [x y])
    #_(ignored form)
    (comment discarded here)
    (try
      (.toUpperCase (String. "s"))
      (Math/abs -1)
      (.getTime (Date.))
      (throw (ex-info "boom" {:code 500}))
      (catch Exception e (.getMessage e))
      (finally (reset! state {})))))
