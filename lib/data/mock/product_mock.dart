import 'package:afyra/models/product.dart';

const productCategories = ['Poleras', 'Hoodies', 'Jeans', 'Tops'];

const mockProducts = <Product>[
  Product(
    id: 'oversize',
    name: 'Polera Oversize Negra',
    category: 'Poleras',
    sku: 'POL-OV-BLK',
    description:
        'Algodón grueso y corte holgado. La prenda base de los directos.',
    cost: 12000,
    price: 24990,
    variants: [
      ProductVariant(color: 'Negro', size: 'S', stock: 2),
      ProductVariant(color: 'Negro', size: 'M', stock: 4),
      ProductVariant(color: 'Negro', size: 'L', stock: 2),
      ProductVariant(color: 'Blanco', size: 'S', stock: 0),
      ProductVariant(color: 'Blanco', size: 'M', stock: 0),
      ProductVariant(color: 'Blanco', size: 'L', stock: 0),
    ],
  ),
  Product(
    id: 'hoodie',
    name: 'Hoodie Essential',
    category: 'Hoodies',
    sku: 'HOD-ESS',
    description: 'Hoodie liviano, capucha doble y puños ajustados.',
    cost: 21000,
    price: 39990,
    variants: [
      ProductVariant(color: 'Negro', size: 'S', stock: 0),
      ProductVariant(color: 'Negro', size: 'M', stock: 1),
      ProductVariant(color: 'Negro', size: 'L', stock: 1),
    ],
  ),
  Product(
    id: 'jeans',
    name: 'Jeans Wide Leg',
    category: 'Jeans',
    sku: 'JNS-WL',
    description: 'Tiro alto y pierna amplia. Se agotó en el último live.',
    cost: 24000,
    price: 42990,
    variants: [
      ProductVariant(color: 'Azul', size: '36', stock: 0),
      ProductVariant(color: 'Azul', size: '38', stock: 0),
      ProductVariant(color: 'Azul', size: '40', stock: 0),
    ],
  ),
  Product(
    id: 'crop',
    name: 'Crop Top Basic',
    category: 'Tops',
    sku: 'CRP-BSC',
    description: 'Crop de algodón, largo a la cintura.',
    cost: 6000,
    price: 12990,
    variants: [
      ProductVariant(color: 'Blanco', size: 'S', stock: 4),
      ProductVariant(color: 'Blanco', size: 'M', stock: 5),
      ProductVariant(color: 'Blanco', size: 'L', stock: 3),
    ],
  ),
  Product(
    id: 'basic',
    name: 'Polera Básica Blanca',
    category: 'Poleras',
    sku: 'POL-BSC',
    description: 'Jersey suave, cuello redondo y calce recto.',
    cost: 9000,
    price: 18990,
    variants: [
      ProductVariant(color: 'Blanco', size: 'S', stock: 1),
      ProductVariant(color: 'Blanco', size: 'M', stock: 2),
      ProductVariant(color: 'Blanco', size: 'L', stock: 1),
    ],
  ),
];

const mockMovements = <StockMovement>[
  StockMovement(
    productName: 'Crop Top Basic',
    variantLabel: 'Blanco · M',
    quantity: 12,
    type: 'Entrada',
    when: '4 oct · 11:20',
  ),
  StockMovement(
    productName: 'Polera Oversize Negra',
    variantLabel: 'Negro · M',
    quantity: -2,
    type: 'Venta',
    when: '5 oct · 21:14',
  ),
  StockMovement(
    productName: 'Hoodie Essential',
    variantLabel: 'Negro · M',
    quantity: -1,
    type: 'Ajuste',
    when: '5 oct · 18:05',
  ),
  StockMovement(
    productName: 'Polera Básica Blanca',
    variantLabel: 'Blanco · S',
    quantity: 6,
    type: 'Entrada',
    when: '3 oct · 16:40',
  ),
  StockMovement(
    productName: 'Jeans Wide Leg',
    variantLabel: 'Azul · 38',
    quantity: -1,
    type: 'Venta',
    when: '2 oct · 20:18',
  ),
];
