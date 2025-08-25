  import * as h from "./dist/hello.js";
  import { Operants as o, Operants } from "./dist/interfaces/docs-adder-types.js";
  
  await h.$init; // this is a parameter with jco
  
  const function_name = 'calculate.evalexpression(str) :';
  //import fsPromises from "node:fs/promises";
  let h1 =document.createElement("h1");
  let html="WASM JCO and Webpack demo";
  h1.innerHTML=html;
  document.body.appendChild(h1);
  
  let element=document.createElement("p");
   html="the result for:  " + function_name +" is ";
  
  html+= h.calculate.evalExpression("");
  const t :Operants={a:1,b:2} 
  var foo =new h.add.Addresource;
  // create a map of operants 
  // implements the interface based on
  // https://stackoverflow.com/questions/13142635/how-can-i-create-an-object-based-on-an-interface-file-definition-in-typescript
  
    html+="<br/> from the add resource :"+ foo.add(t);
  element.innerHTML=html;
  document.body.appendChild(element);

  