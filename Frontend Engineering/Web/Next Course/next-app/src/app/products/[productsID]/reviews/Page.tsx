export default function reviews({ params }: { params: { productID: string } }) {
  return (
    <>
      <h1>welcome to reviews of {params.productID}</h1>
      <h2>reviews 1</h2>
      <h2>reviews 2</h2>
      <h2>reviews 3</h2>
    </>
  );
}
