export default function DetailProduct({
  params,
}: {
  params: { productsID: string };
}) {
  return <h1>Details of product {params.productsID}</h1>;
}
