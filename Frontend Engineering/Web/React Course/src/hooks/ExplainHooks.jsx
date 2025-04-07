import React from "react";
import StateExample from "./State";
import EffectExample from "./Effects";
import ReducerExample from "./Reducer";
import CallbackExample from "./CallBack";
import MemoExample from "./Memo";
import RefExample from "./Refs";
import LayoutEffectExample from "./LayoutEffect";
import ImperativeHandleExample from "./Imperative";
import DebugValueExample from "./DebugValue";

const ExplainHooks = () => {
  return (
    <div className="p-4 space-y-8">
      <section className="h-72">
        <h1 className="text-2xl font-bold">useState</h1>
        <hr className="border-b-2 border-gray-200 mb-4" />
        <StateExample />
      </section>

      <section>
        <h1 className="text-2xl font-bold">useEffect</h1>
        <hr className="border-b-2 border-gray-200 mb-4" />
        <EffectExample />
      </section>

      <section>
        <h1 className="text-2xl font-bold">useReducer</h1>
        <hr className="border-b-2 border-gray-200 mb-4" />
        <ReducerExample />
      </section>

      <section>
        <h1 className="text-2xl font-bold">useCallback</h1>
        <hr className="border-b-2 border-gray-200 mb-4" />
        <CallbackExample />
      </section>

      <section>
        <h1 className="text-2xl font-bold">useMemo</h1>
        <hr className="border-b-2 border-gray-200 mb-4" />
        <MemoExample />
      </section>

      <section>
        <h1 className="text-2xl font-bold">useRef</h1>
        <hr className="border-b-2 border-gray-200 mb-4" />
        <RefExample />
      </section>

      <section>
        <h1 className="text-2xl font-bold">useLayoutEffect</h1>
        <hr className="border-b-2 border-gray-200 mb-4" />
        <LayoutEffectExample />
      </section>

      <section>
        <h1 className="text-2xl font-bold">useImperativeHandle</h1>
        <hr className="border-b-2 border-gray-200 mb-4" />
        <ImperativeHandleExample />
      </section>

      <section>
        <h1 className="text-2xl font-bold">useDebugValue</h1>
        <hr className="border-b-2 border-gray-200 mb-4" />
        <DebugValueExample />
      </section>
    </div>
  );
};

export default ExplainHooks;
